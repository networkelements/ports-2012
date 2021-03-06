# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/neutron/neutron-2013.1.9999.ebuild,v 1.11 2013/11/10 23:04:52 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2

#restricted due to packages missing and bad depends in the test ==webob-1.0.8   
RESTRICT="test"
DESCRIPTION="Quantum is a virtual network service for Openstack."
HOMEPAGE="https://launchpad.net/neutron"
EGIT_REPO_URI="https://github.com/openstack/neutron.git"
EGIT_BRANCH="stable/grizzly"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+dhcp +l3 +metadata +openvswitch +server test sqlite mysql postgres"
REQUIRED_USE="|| ( mysql postgres sqlite )"

#the cliff dep is as below because it depends on pyparsing, which only has 2.7 OR 3.2, not both
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		app-admin/sudo
		test? ( dev-python/cliff[${PYTHON_USEDEP}]
				dev-python/configobj[${PYTHON_USEDEP}]
				dev-python/coverage[${PYTHON_USEDEP}]
				>=dev-python/mock-1.0[${PYTHON_USEDEP}]
				~dev-python/mox-0.5.3[${PYTHON_USEDEP}]
				dev-python/nose[${PYTHON_USEDEP}]
				dev-python/nosehtmloutput[${PYTHON_USEDEP}]
				dev-python/nosexcover[${PYTHON_USEDEP}]
				dev-python/openstack-nose-plugin[${PYTHON_USEDEP}]
				~dev-python/pep8-1.4.5[${PYTHON_USEDEP}]
				>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
				~dev-python/webtest-1.3.3[${PYTHON_USEDEP}]
				virtual/python-unittest2[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
		>=dev-python/alembic-0.4.1[${PYTHON_USEDEP}]
		dev-python/paste[${PYTHON_USEDEP}]
		>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
		>=dev-python/amqplib-0.6.1-r1[${PYTHON_USEDEP}]
		>=dev-python/anyjson-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.9.17[${PYTHON_USEDEP}]
		>=dev-python/greenlet-0.3.1[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/iso8601-0.1.4[${PYTHON_USEDEP}]
		>=dev-python/kombu-1.0.4-r1[${PYTHON_USEDEP}]
		dev-python/netaddr[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-0.2.0[${PYTHON_USEDEP}]
		dev-python/python-novaclient[${PYTHON_USEDEP}]
		>=dev-python/python-neutronclient-2.2.0[${PYTHON_USEDEP}]
		<=dev-python/python-neutronclient-3.0.0[${PYTHON_USEDEP}]
		dev-python/pyudev[${PYTHON_USEDEP}]
		sqlite? ( >=dev-python/sqlalchemy-0.7.8[sqlite,${PYTHON_USEDEP}]
	          <dev-python/sqlalchemy-0.7.10[sqlite,${PYTHON_USEDEP}] )
		mysql? ( >=dev-python/sqlalchemy-0.7.8[mysql,${PYTHON_USEDEP}]
	         <dev-python/sqlalchemy-0.7.10[mysql,${PYTHON_USEDEP}] )
		postgres? ( >=dev-python/sqlalchemy-0.7.8[postgres,${PYTHON_USEDEP}]
	            <dev-python/sqlalchemy-0.7.10[postgres,${PYTHON_USEDEP}] )
		>=dev-python/webob-1.2[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-1.1.0[${PYTHON_USEDEP}]
		<dev-python/oslo-config-1.2.0[${PYTHON_USEDEP}]
		virtual/python-argparse[${PYTHON_USEDEP}]
		net-misc/bridge-utils
		openvswitch? ( net-misc/openvswitch )
		dhcp? ( net-dns/dnsmasq[dhcp-tools] )"

pkg_setup() {
	enewgroup neutron
	enewuser neutron -1 -1 /var/lib/neutron neutron
}

python_install() {
	distutils-r1_python_install
	newconfd "${FILESDIR}/neutron-confd" "quantum"
	newinitd "${FILESDIR}/neutron-initd" "quantum"

	use server && dosym /etc/init.d/quantum /etc/init.d/quantum-server
	use dhcp && dosym /etc/init.d/quantum /etc/init.d/quantum-dhcp-agent
	use l3 && dosym /etc/init.d/quantum /etc/init.d/quantum-l3-agent
	use metadata && dosym /etc/init.d/quantum /etc/init.d/quantum-metadata-agent
	use openvswitch && dosym /etc/init.d/quantum /etc/init.d/quantum-openvswitch-agent

	diropts -m 750
	dodir /var/log/neutron /var/log/quantum
	fowners neutron:neutron /var/log/neutron
	keepdir /etc/quantum
	insinto /etc/quantum

	#it's /bin/ip not /sbin/ip
	sed -i 's/sbin\/ip\,/bin\/ip\,/g' "etc/quantum/rootwrap.d/*"

	doins "etc/api-paste.ini"
	doins "etc/dhcp_agent.ini"
	doins "etc/l3_agent.ini"
	doins "etc/policy.json"
	doins "etc/quantum.conf"
	doins "etc/rootwrap.conf"
	insinto /etc
	doins -r "etc/quantum/"

	#remove the etc stuff from usr...
	rm -R "${D}/usr/etc/"

	insinto "/usr/lib64/python2.7/site-packages/quantum/db/migration/alembic_migrations/"
	doins -r "quantum/db/migration/alembic_migrations/versions"

	#add sudoers definitions for user neutron
	insinto /etc/sudoers.d/
	doins "${FILESDIR}/neutron-sudoers"
}

pkg_config() {
	fperms 0700 /var/log/neutron
	fowners neutron:neutron /var/log neutron
}
