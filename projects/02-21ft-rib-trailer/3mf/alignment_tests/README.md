# Fullskala ramme-/alignment-test

> **FORELDET 2026-08-30:** Denne pakken tester den tidligere platebaserte
> rammen. Ikke print den på nytt og ikke bruk den som produksjonsgodkjenning.
> Bruk først `../integrated_joint_tests/integrated_frame_joint_test.3mf`.

Skriv ut begge fanene i `frame_alignment_test.3mf` før videre produksjon i
PETG. Prosjektet inneholder 23 objekter og bruker Bambu Lab A1 med 0,4 mm dyse,
0,20 mm lag, 215 °C dyse, 55 °C plate, fire vegger, fem topp-/bunnlag og
15 % gyroid. Velg PolySmart PLA Phantom Black og korrekt fysisk byggeplate i
Bambu Studio før utskrift.

## Innhold

- `alignment_drawbar_front` × 1
- `alignment_drawbar_rear` × 1
- `alignment_frame_rail_middle` × 2
- `alignment_frame_rail_rear` × 2
- `alignment_crossmember` × 1
- `alignment_crossmember_mid` × 1
- `alignment_rear_accessory_crossmember` × 1
- `splice_plate` × 2
- `v_rail_joint_plate` × 4
- `crossmember_joint_plate_mid` × 4
- `crossmember_joint_plate_rear` × 4

## Montering og godkjenning

Se `assembly_map_top.png`. Nummereringen er:

- **1:** Fremre V-del med koblingsenden og den lange senterstripen.
- **2:** Bakre V-del; den brede enden møter fremre tverrbjelke.
- **3:** To like mellomvanger, omtrent 164 mm lange.
- **4:** To like bakvanger, omtrent 145 mm lange.
- **5:** Fremre tverrbjelke, 220 mm lang. Den ligger mellom V-del 2 og vange 3.
- **6:** Midtre tverrbjelke. Denne er kortere enn de to andre og ligger mellom vangene.
- **7:** Bakre tverrbjelke, 220 mm lang. Endene ligger rett bak bakvangene.

De løse platene identifiseres slik:

- **2 lange, smale plater:** Utvendige skjøtelasker mellom vange 3 og 4.
- **4 brede trehullsplater:** Over og under forbindelsen mellom V-del 2,
  tverrbjelke 5 og vange 3, én på hver side av rammen.
- **4 korte tohullsplater med tydelig forskjøvne hull:** Over og under hver ende
  av midtre tverrbjelke 6.
- **4 korte tohullsplater med hull nesten på linje:** Over og under hver ende av
  bakre tverrbjelke 7.

1. Monter V-frontens to halvdeler med to M3-bolter per arm.
2. Monter den fremre tverrbjelken mellom V-bakdelen og hovedvangene med én
   V-/vangeskjøteplate over og under på hver side.
3. Monter midt- og aktervanger ende mot ende med én utvendig skjøtelask per
   side.
4. Monter midtre og bakre tverrbjelke med én plate over og under på hver side.
5. Legg rammen på et plant bord uten å tvinge delene på plass.
6. Kontroller at rammen ligger plant, er symmetrisk, har parallelle vanger,
   riktig V-vinkel og gjennomgående hull som flukter på begge sider.

Stopp før PETG-utskrift dersom deler må bøyes, files eller trekkes på plass med
boltene. Mål avviket og korriger den delte produksjonsparameteren. Denne
PLA-testen kontrollerer geometri og monteringslogikk, ikke styrke eller endelig
PETG-klaring.

## Fysisk teststatus 2026-08-30

Del 1–2–5, forbindelsen 2/3/5 på begge sider, 3–6 og sideskjøten 3–4 passer.
Sidehullene i del 3 var skjult av støtte-/plastrester og ble funnet etter
opprenskning; de manglet ikke i modellen. M3-hullene i bakre tverrbjelke 7 er
litt for trange, men delene står ikke i spenn. Hullene kan bores opp i denne
PLA-testen for å fullføre geometri- og alignment-kontrollen.

Testen er ikke endelig godkjent før del 7 er montert og hele rammen er
kontrollert plan og symmetrisk. Klaringen i del 7 skal bekreftes med en liten
PETG-kupong før PETG-restsettet startes.
