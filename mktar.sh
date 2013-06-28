#! /bin/sh

cd ~/dev/aatw
[ -d /tmp/aatw ] || mkdir /tmp/aatw
cp * /tmp/aatw -Rv
cd /tmp/aatw && (
	rm aatw.sqlite3
	rm *.sublime-*
	rm mktar.sh
	rm sample.rpt
	mv specs/order.csv .
	rm specs/*
	rmdir specs
	./importer.pl order.csv
	./reporter.pl > sample.rpt
	cd ..
	tar Jcvf aatw.xz aatw
	ls -l aatw.xz
	)
cd ~/dev/aatw