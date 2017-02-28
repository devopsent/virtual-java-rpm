VERSION ?= 1.6.0
RELEASE ?= 2
PACKAGE ?= virtual-java
RPMNAME=$(PACKAGE)-$(VERSION)-$(RELEASE).noarch.rpm

.PHONY: all
all: dist/$(RPMNAME)

.PHONY: clean
clean:
	rm -rf work
	rm -rf dist

dist/$(RPMNAME): work/RPMS/noarch/$(RPMNAME) dist
	cp work/RPMS/noarch/$(RPMNAME) dist/$(RPMNAME)

work/RPMS/noarch/$(RPMNAME): work/BUILD work/RPMS/noarch work/SPECS/$(PACKAGE).spec
	rpmbuild -bb --define="_topdir ${PWD}/work" work/SPECS/$(PACKAGE).spec

work/SPECS/$(PACKAGE).spec: work/SPECS $(PACKAGE).spec
	cat $(PACKAGE).spec | sed -e "s/%VERSION%/$(VERSION)/g; s/%RELEASE%/$(RELEASE)/g" > work/SPECS/$(PACKAGE).spec

dist:
	if [ ! -d dist ]; then mkdir -p dist; fi
	touch dist
work/BUILD:
	if [ ! -d work/BUILD ]; then mkdir -p work/BUILD; fi
	touch work/BUILD
work/RPMS/noarch:
	if [ ! -d work/RPMS/noarch ]; then mkdir -p work/RPMS/noarch; fi
	touch work/RPMS/noarch
work/SPECS:
	if [ ! -d work/SPECS ]; then mkdir -p work/SPECS; fi
	touch work/SPECS

