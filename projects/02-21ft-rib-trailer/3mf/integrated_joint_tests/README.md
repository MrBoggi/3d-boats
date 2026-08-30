# Test av integrerte rammeskjøter

Skriv ut `integrated_frame_joint_test.3mf` i PolySmart PLA Phantom Black før
noen ny full ramme eller PETG-produksjon. Filen har én A1-fane og 11 objekter.
Profilen er 0,20 mm lag, 215 °C dyse, 55 °C plate, fire vegger, fem
topp-/bunnlag og 15 % gyroid. Kontroller filament og fysisk byggeplate i Bambu
Studio før utskrift.

## Hardware

- 8 × RUTHEX RX-M3×5.7 smeltemutter, monteringshull Ø4,0 × 6,0 mm
- 8 × M3×14 sylinderhodebolt, målt hode Ø4,95 × 3,4 mm

Smeltemutteren monteres fra undersiden av underdelen og settes plant med
undersiden. Bolten føres fra oversiden; hodet skal ligge i Ø5,2 × 3,6 mm
forsenkningen. Ikke bruk lim eller puss anleggsflatene under testen.

## Par og monteringsretning

1. `fit_v_front` over `fit_v_rear` — to bolter.
2. `fit_front_v` og `fit_front_rail` over hver sin tunge på
   `fit_front_crossmember` — to bolter totalt.
3. `fit_splice_front` over `fit_splice_rear` — to bolter.
4. `fit_mid_rail` over `fit_mid_crossmember` — én bolt.
5. `fit_rear_rail` over `fit_rear_crossmember` — én bolt.

## Godkjenning

- Smeltemutteren kan settes inn uten sprekk eller synlig deformasjon.
- Overdelen glir helt ned på underdelen uten filing eller tvang.
- 0,3 mm nominell vertikalklaring gir ingen merkbar vippefeil etter tiltrekking.
- M3-bolten går lett gjennom Ø3,4 mm-hullet og griper smeltemutteren uten å
  trekke delene sideveis.
- Bolthodet ligger plant eller lavere enn overflaten.
- Skjøten kan demonteres uten skade på plast eller innsats.

Rapporter eventuelle avvik i millimeter. Ikke start full alignment-test eller
PETG-restsett før alle fem grensesnitt er fysisk godkjent.

Pakken regenereres med `python3 scripts/build_integrated_joint_test.py` i
prosjektmappen. Generatoren bruker de validerte én-del-3MF-filene i `parts/`.
