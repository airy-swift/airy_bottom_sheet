fix:
	fvm dart fix --apply
	fvm dart format lib -l 200

get:
	fvm flutter clean
	fvm flutter pub get

