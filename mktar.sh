#! /bin/sh

cd ~/dev/aatw
rm -rf /tmp/aatw* -v
[ -d /tmp/aatw ] || mkdir /tmp/aatw
cp * /tmp/aatw -Rv
cd /tmp/aatw && (
	rm aatw.sqlite3 -v
	rm *.sublime-* -v
	rm mktar.sh -v
	rm sample.rpt -v
	mv specs/orders.csv . -v
	rm specs/* -v
	rmdir specs -v
	./importer.pl ./orders.csv
	./reporter.pl > ./sample.rpt
	cd ..
	tar Jcvf aatw.tar.xz aatw
	zip -r aatw.zip aatw
	ls -l aatw*
	)
cd ~/dev/aatw