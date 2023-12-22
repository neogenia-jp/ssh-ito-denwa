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
/usr/local/lib/ssh-ito-denwa/*
/etc/ssh-ito-denwa.conf
/usr/lib/systemd/system/ssh-ito-denwa.service

%post
cp /usr/lib/systemd/system/ssh-ito-denwa/src/config \
	  /etc/ssh-ito-denwa.conf

ln -sf /usr/local/lib/ssh-ito-denwa/ssh-ito-denwa.service /usr/lib/systemd/system/

systemctl daemon-reload

%preun

systemctl stop ssh-ito-denwa || true
systemctl disable ssh-ito-denwa || true

rm /usr/lib/systemd/system/ssh-ito-denwa.service 

if diff /usr/lib/systemd/system/ssh-ito-denwa/src/config /etc/ssh-ito-denwa.conf; then
  rm -f /etc/systemd/system/multi-user.target.wants/ssh-ito-denwa.service
else
  mv /etc/ssh-ito-denwa.conf /etc/ssh-ito-denwa.conf.bkup
fi

systemctl daemon-reload

