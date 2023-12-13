Name:      ssh-ito-denwa
Version:   0.0.1
Release:   1
Group:     Networking Tools
Vendor:    Neogenia Ltd.
License:   MIT License
Summary:   Reverse SSH Port Forwarding daemon for neorok
BuildArch: noarch

# use build-time generated tar ball.
Source0:   %{name}.tar.gz

BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%define INSTALL_DIR %{buildroot}

%description
%{summary}

%prep

%setup -q -n %{name}

%build

%install
rm -rf %{INSTALL_DIR}/
mkdir -p %{INSTALL_DIR}/
cp -Rp * %{INSTALL_DIR}/

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
/usr/lib/systemd/user/ssh-ito-denwa/*
/etc/ssh-ito-denwa.conf
/etc/systemd/user/ssh-ito-denwa.service

%post
cp /usr/lib/systemd/user/ssh-ito-denwa/src/config \
	  /etc/ssh-ito-denwa.conf

ln -sf /etc/systemd/user/ssh-ito-denwa/service-def /usr/lib/systemd/user/ssh-ito-denwa.service

%preun

rm -f /etc/systemd/user/ssh-ito-denwa.service

