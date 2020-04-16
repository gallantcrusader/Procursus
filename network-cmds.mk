ifneq ($(CHECKRA1N_MEMO),1)
$(error Use the main Makefile)
endif

SUBPROJECTS          += network-cmds
DOWNLOAD             += https://opensource.apple.com/tarballs/network_cmds/network_cmds-$(NETWORK-CMDS_VERSION).tar.gz
NETWORK-CMDS_VERSION := 596
DEB_NETWORK-CMDS_V   ?= $(NETWORK-CMDS_VERSION)

network-cmds-setup: setup
	$(call EXTRACT_TAR,network_cmds-$(NETWORK-CMDS_VERSION).tar.gz,network_cmds-$(NETWORK-CMDS_VERSION),network-cmds)
	mkdir -p $(BUILD_STAGE)/network-cmds/{{s,}bin,usr/{{s,}bin,libexec}}

	# Mess of copying over headers because some build_base headers interfere with the build of Apple cmds.
	mkdir -p $(BUILD_WORK)/network-cmds/include/sys
	cp -a $(MACOSX_SYSROOT)/usr/include/nlist.h $(BUILD_WORK)/network-cmds/include
	mkdir -p $(BUILD_WORK)/network-cmds/include/net/{classq,pktsched}

	@#TODO: Needs severe cleaning. Was done late at night.

	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include \
		https://opensource.apple.com/source/Libc/Libc-1353.11.2/include/unistd.h
	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include/net \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/net_api_stats.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_bridgevar.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/ntstat.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_llreach.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/route.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_mib.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_arp.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_media.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/radix.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/net_perf.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_6lowpan_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_bond_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/network_agent.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_fake_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_vlan_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_fake_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/lacp.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/if_bond_internal.h
	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include/net/pktsched \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/pktsched/pktsched.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/pktsched/pktsched_netem.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/pktsched/pktsched_tcq.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/pktsched/pktsched_qfq.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/pktsched/pktsched_fq_codel.h
	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include/net/classq \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/classq/classq.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/classq/if_classq.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/classq/classq_red.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/classq/classq_blue.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/classq/classq_rio.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/net/classq/classq_sfb.h
	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include/netinet \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/mptcp_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/in_stat.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/in.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/tcp.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/tcp_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/ip_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/udp_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/if_ether.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/tcpip.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/icmp_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/igmp_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/tcp_seq.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/tcp_fsm.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/in_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet/in_pcb.h
	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include/netinet6 \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/ip6_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/in6_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/in6.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/nd6.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/mld6_var.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/in6_pcb.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/netinet6/raw_ip6.h
	@wget -q -nc -P $(BUILD_WORK)/network-cmds/include/sys \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/socket.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/unpcb.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/kern_event.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/kern_control.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/socketvar.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/sys_domain.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/mbuf.h \
		https://opensource.apple.com/source/xnu/xnu-6153.11.26/bsd/sys/sockio.h
	
	$(SED) -i 's/#if INET6/#ifdef INET6/g' $(BUILD_WORK)/network-cmds/include/sys/sockio.h

ifneq ($(wildcard $(BUILD_WORK)/network-cmds/.build_complete),)
network-cmds:
	@echo "Using previously built network-cmds."
else
network-cmds: .SHELLFLAGS=-O extglob -c
network-cmds: network-cmds-setup
	cd $(BUILD_WORK)/network-cmds; \
	for tproj in !(ping|rtadvd|rarpd|spray).tproj; do \
		tproj=$$(basename $$tproj .tproj); \
		echo $$tproj; \
    	$(CC) -arch $(ARCH) -isysroot $(SYSROOT) $($(PLATFORM)_VERSION_MIN) -isystem include -o $$tproj $$tproj.tproj/!(ns).c ecnprobe/gmt2local.c -DPRIVATE -DINET6 -DPLATFORM_iPhoneOS -D__APPLE_USE_RFC_3542=1 -DUSE_RFC2292BIS=1 -D__APPLE_API_OBSOLETE=1 -DTARGET_OS_EMBEDDED=1 -Dether_ntohost=_old_ether_ntohost; \
	done
	cp -a $(BUILD_WORK)/network-cmds/kdumpd $(BUILD_STAGE)/network-cmds/usr/libexec
	cp -a $(BUILD_WORK)/network-cmds/{arp,ndp,traceroute,mnc,mtest,traceroute6,ifconfig,ip6addrctl,netstat,ping6,route,rtsol} $(BUILD_STAGE)/network-cmds/usr/sbin
	cd $(BUILD_STAGE)/network-cmds/usr/sbin; \
	for bin in ifconfig ip6addrctl netstat ping6 route rtsol; do \
		$(LN) -sf ../usr/sbin/$$bin $(BUILD_STAGE)/network-cmds/sbin; \
	done
	$(LN) -sf ../usr/sbin/ping6 $(BUILD_STAGE)/network-cmds/bin
	touch $(BUILD_WORK)/network-cmds/.build_complete
endif

network-cmds-package: network-cmds-stage
	# network-cmds.mk Package Structure
	rm -rf $(BUILD_DIST)/network-cmds
	
	# network-cmds.mk Prep network-cmds
	$(FAKEROOT) cp -a $(BUILD_STAGE)/network-cmds $(BUILD_DIST)

	# network-cmds.mk Sign
	$(call SIGN,network-cmds,general.xml)
	
	# network-cmds.mk Make .debs
	$(call PACK,network-cmds,DEB_NETWORK-CMDS_V)
	
	# network-cmds.mk Build cleanup
	rm -rf $(BUILD_DIST)/network-cmds

.PHONY: network-cmds network-cmds-package
