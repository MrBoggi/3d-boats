# Overlevering til Claude – 21 ft RIB-henger

Oppdatert: 2026-08-22. Dette dokumentet er skrevet for å kunne fortsette arbeidet på en annen PC uten tilgang til den opprinnelige chatten.

## Repository og Git-status

- GitHub: `https://github.com/MrBoggi/3d-boats.git`
- Standardgren: `main` (ikke `master`).
- Trailerprosjekt: `projects/02-21ft-rib-trailer/`.
- Båtreferanse: `projects/01-21ft-rib/`.
- PR #1 med hovedprosjektet er merget til `main` som commit `fccb6a9`.
- Etter merge ble grenen `agent/add-trailer-fit-test-plate` opprettet for testpakken og siste rettelser. Se siste Git-logg for aktuell commit etter checkout.

## Brukerens mål og prioriteringer

Det bygges en printbar 1:10 boggihenger for prosjekt 01 sin 21-fots RIB. Båten, originalmotoren og vei-referansen vises i `assembly.scad`. Brukeren prioriterer nå å unngå mer bortkastet PETG etter at første store prøveutskrift viste at frontdelene ikke fysisk kunne monteres, selv om hullene så riktige ut digitalt.

Viktig skille:

1. Lokal klaring/passform i en skjøt.
2. At store deler faktisk har riktig totallengde, vinkel, hullplassering og monteringsrekkefølge.

Brukeren er mest bekymret for punkt 2. Ikke be brukeren printe `3mf/remaining_after_trial/` før både lokal skjøtetest og en fullskala, materialbesparende ramme-/alignment-test er fysisk godkjent.

## Designstatus

Hengeren har blant annet:

- todelt V-front;
- parallelle hovedvanger;
- boggiarmer, kjøpehjul og sekskantadaptere;
- fire V-formede kjølruller;
- fire doble, leddede siderullestøtter;
- buede tandemskjermer med tett innside;
- vinsjtårn, trommel, sveiv og vippbar TPU V-baugstopp;
- fremre kjøpeadapter for omtrent 6 mm RC-kule;
- baklys på bjelken foran motorens åpne sone og sideforskjøvet skiltplate;
- original båtmotor og vei som klaringsreferanser.

Alle hovedmål og klaringer ligger i `scad/config.scad`. Produksjonssammenstillingen ligger i `scad/assembly.scad`; ikke dupliser mål i nye moduler.

## Viktige skjøteredign

Ny produksjonsrevisjon 2026-08-30 erstatter de løse rammeskjøteplatene med
integrerte halv-i-halv-skjøter. Overdelene har Ø3,4 mm klaringshull og
Ø5,2 × 3,6 mm lomme for målt M3-sylinderhode. Underdelene har Ø4,0 × 6,0 mm
blindlomme fra undersiden for RUTHEX RX-M3×5.7. Nominell vertikalklaring er
0,3 mm. Dette gjelder V-skjøten, V/frontbjelke/vange-knutepunktet,
vangskjøten, midtbjelken og bakbjelken. Tidligere `splice_plate`,
`v_rail_joint_plate` og `crossmember_joint_plate_*` er utgått fra
produksjonssammenstillingen.

Ny obligatorisk kupongfil er
`3mf/integrated_joint_tests/integrated_frame_joint_test.3mf`: én A1-fane,
11 PLA-objekter. Alle 11 kuponger er CGAL-rendret `Simple: yes`; fire nye
skjøtekollisjonsmoduler gir tom interseksjon. Fysisk godkjenning gjenstår.

Første fysiske prøveprint avslørte at `drawbar_front` og `drawbar_rear` var to massive bjelker i samme volum. Hullene fluktet, men delene kunne bare legges oppå hverandre. Dette er rettet til komplementære halv-i-halv-skjøter med nominell 0,3 mm vertikal printklaring og to M3-bolter per V-arm.

Andre korrigeringer:

- koblingsadapteren har halv-i-halv-tunge mot senterbjelken;
- midtbjelken stopper 0,3 mm innenfor vangene og bruker egne plater over og under;
- bakre lysbjelke starter 0,3 mm bak vangeendene og bruker egne plater over og under;
- kun utvendige lasker brukes ved vangskjøten ved X = 440 mm;
- siderullestøtten har rundt hovedpivotnav i gaffel og egen sekundærpivot per rulle;
- vuggehullet ble flyttet 0,2 mm for å unngå tangent/non-manifold toppflate.

Under utvikling av fit-testen ble enda en reell produksjonsfeil funnet: V-armene ble unionert over adapterens to M3-hull og fylte dem igjen. `scad/frame.scad` er nå rettet slik at hullene skjæres gjennom den komplette frontunionen. `drawbar_front.stl`, enkelt-3MF og berørte plateprosjekter er regenerert.

## Digital validering

Reproduksjonskommando:

```bash
projects/02-21ft-rib-trailer/scripts/check_joint_interfaces.sh
```

Siste kjente resultat:

- 31/31 gjeldende produksjonsdeler er ikke-tomme og `Simple: yes`;
- 12/12 kritiske kollisjonsmoduler gir tom interseksjon;
- fit-testplaten slicer med returkode 0, 18 objekter og ingen advarsler;
- alle fire `remaining_after_trial`-prosjektene slicer med returkode 0 og ingen advarsler.

OpenSCAD finnes på verten og kan kjøres med `flatpak-spawn --host openscad`. Bambu Studio er Flatpak `com.bambulab.BambuStudio`. Miljøet kan vise en ufarlig OpenGL/GLFW-feil i headless modus selv om 3MF-filen blir skrevet; verifiser alltid filstørrelse og slicerapport.

## Fit-testpakken på aktuell gren

Filer:

- `3mf/fit_tests/fit_test_plate_01.3mf`;
- `3mf/fit_tests/README.md`;
- `scad/fit_tests.scad`;
- `scripts/build_fit_test_plate.py`;
- `stl/fit_tests/`.

Pakken har én A1-fane med 18 objekter og tester i full skala:

- V-frontens halv-i-halv-skjøt;
- adaptertunge og begge M3-hull;
- vangskjøt og utvendig lask;
- midtbjelke med over-/underplate;
- bakre lysbjelke med over-/underplate;
- hoved- og sekundærpivot i siderullestøtten.

Kupongene er klippet direkte fra produksjonsmodulene. Mål, hull og anleggsflater skal derfor være identiske. Testen skal monteres med reelle M3-skruer, skiver og muttere.

Denne platen tester lokale grensesnitt. Den løser ikke alene brukerens hovedbekymring om global geometri i de store delene.

## Fullskala ramme-/alignment-test

Et separat fullskala `frame_alignment_test` med lavt materialforbruk er implementert:

- hele V-fronten i korrekt lengde og vinkel;
- hele hovedvangene;
- hele fremre, midtre og bakre tverrbjelke;
- alle produksjonshull og alle nødvendige festeplater;
- full produksjonstykkelse bare lokalt rundt skjøter/hull;
- 2–3 mm tynne ribber eller web mellom skjøteområdene.

Målet er at hele rammen kan skrus sammen på et bord og avsløre feil lengde, vinkel, sidevalg, hullplassering eller monteringslogikk med vesentlig mindre plast enn massive produksjonsdeler. Bruk faktisk produksjonsgeometri og delte parametere; ikke tegn uavhengige kopier.

Den ferdige filen er `3mf/alignment_tests/frame_alignment_test.3mf` med to A1-faner og 23 objekter. Testdelene beholder produksjonsgeometri og full tykkelse rundt skjøter/hull, med en 2,4 mm web mellom kontrollpunktene. Valgt testmateriale er PolySmart PLA Phantom Black, 1,75 mm. Profilen bruker 215 °C dyse, 55 °C plate, 0,20 mm lag, fire vegger, fem topp-/bunnlag og 15 % gyroid. Kritiske endelige klaringer skal likevel bekreftes med små PETG-kuponger. PLA-testen er ikke en styrketest.

## Fysisk utskrift som allerede er gjort

Brukerens opplysning:

- begge fysiske faner i gamle PETG-prosjekt 01 er printet;
- begge fysiske faner i gamle PETG-prosjekt 02 er printet;
- bare første fysiske fane i gamle PETG-prosjekt 03 er printet;
- vinsjtårnet manglet fysisk, selv om gammel 3MF-metadata plasserte det på fane 1;
- TPU-baugstopp er behandlet som ikke printet med mindre brukeren sier noe annet.

### Fysisk PLA alignment-test 2026-08-30

Begge fanene av `frame_alignment_test.3mf` er printet i PolySmart PLA Phantom
Black. Foreløpig fysisk resultat:

- del 1 mot 2 passer;
- del 1/2 mot fremre tverrbjelke 5 passer;
- mellomvange 3 mot midtre tverrbjelke 6 ser ut til å passe;
- forbindelsen 2/3/5 passer på begge sider etter at støtte-/plastrester ble
  fjernet fra hullene i del 3;
- sideforbindelsen mellom vange 3 og 4 passer etter samme opprenskning;
- sidehullene i del 3 var til stede i CAD og print, men skjult av støtte og
  plastrester;
- M3-hullene i bakre tverrbjelke 7 er litt for trange, men geometrien står ikke
  i spenn. Hullene kan bores opp i PLA-testen for å fullføre alignment-kontrollen.

Alignment-testen er fortsatt ikke endelig godkjent før hele rammen er montert
med del 7, ligger plant og er kontrollmålt. Den trange M3-klaringen i del 7 må
bekreftes med en liten PETG-kupong før PETG-restsettet startes.

Deler som kan beholdes og brukes:

- 2 boggiarmer;
- 2 boggifestebraketter;
- 2 tandemskjermer;
- 1 skjermfeste (ett til mangler);
- 4 hjulsekskantadaptere;
- 4 kjølruller;
- 2 fremre kjølrullebraketter;
- 2 midt-fremre kjølrullebraketter;
- 4 sidestøttemottakere;
- 2 baklyshus;
- 1 vinsjtrommel;
- 1 vinsjsveiv;
- 2 skjøtelasker;
- 1 standard fremre tverrbjelke.

Reservedeler:

- 2 ekstra skjøtelasker;
- 1 ekstra gammel standardtverrbjelke, som ikke erstatter den nye korte `crossmember_mid`.

Gamle print som ikke skal brukes i revidert sammenstilling:

- `drawbar_front` og `drawbar_rear`;
- 2 `frame_rail_middle` og 2 `frame_rail_rear`;
- gammel `rear_accessory_crossmember`;
- gammel `coupler_mount_adapter`;
- 4 gamle `side_double_roller_cradle`;
- 8 gamle `side_roller_wobble_holder`.

## Restutskriftssett

`3mf/remaining_after_trial/` inneholder 54 PETG-deler og én TPU-del fordelt på seks fysiske faner. Det ble beregnet fra utskriftshistorikken over og inkluderer uprintede samt redesignede deler. `winch_tower_body` er eksplisitt inkludert.

Dette settet er digitalt gyldig, men skal regnes som blokkert til testene er fysisk godkjent. Hvis modeller endres etter test, må individuelle STL/3MF, fullplater og restplater regenereres; ikke la gamle binærfiler bli liggende.

Etter revisjonen 2026-08-30 er de eksisterende filene i
`3mf/remaining_after_trial/` og `3mf/plates/` foreldet og skal ikke printes.
De regenereres først etter fysisk godkjenning av den nye integrerte
skjøtekupongen.

## Print- og materialstrategi

Produksjonsprofilen i 3MF er i hovedsak:

- Bambu Lab A1, 0,4 mm dyse, 0,20 mm lag;
- Generic PETG;
- 4 vegger;
- 5 topp- og bunnlag;
- 35 % gyroid;
- `normal(auto)` støtte på fullplatene der nødvendig;
- TPU for baugstoppen.

Produksjons-PETG er ikke strukturelt lasttestet. Hengeren skal ikke merkes ferdig før fysisk lasttest, klaringstest, motor-/bakkeklaring og faktisk kuletrykk er dokumentert.

## Kjøpekomponenter og maskinvare

README-en er autoritativ for lenker og konvolutter. Viktige valg:

- kjøpehjul omtrent 65 mm diameter, 27 mm bredde, 12 mm sekskant og M4 akselmutter;
- kjøpt RC-kobling for omtrent 5,8–6,0 mm kule, M3-grensesnitt;
- øvrige rammeskjøter og pivoter hovedsakelig M3;
- baugøye tilhører båtprosjektet, ikke hengeren;
- vinsjstroppen er en 1:10 mockup og skal ikke detaljstyre rammegeometrien uten mål på faktisk produkt.

## Arbeidsregler for videreføring

1. Les `.codex/skills/openscad-modeling/SKILL.md` og prosjektets README før endringer.
2. Bevar parametrisk kilde; ikke patch bare STL/3MF.
3. Enhver produksjonsendring skal etterfølges av alle relevante STL- og 3MF-eksporter.
4. Rendér hver endret del med CGAL og krev `Simple: yes`.
5. Legg til eksplisitt kollisjonsmodul eller fysisk kupong for nye grensesnitt.
6. Ikke anta at hull som flukter betyr at delene kan monteres; kontroller volum, side, verktøytilgang og monteringsrekkefølge.
7. Ikke be om full PETG-utskrift før billig fullskala alignment-test og små PETG-kuponger er godkjent.
8. Oppdater dette dokumentet og README når fysisk test gir nye mål eller beslutninger.
9. Bygg fullskala geometri- og alignment-tester som materialbesparende skjelettdeler: bruk direkte interseksjon med faktisk produksjonsgeometri, behold full produksjonstykkelse lokalt rundt alle skjøter, hull og anleggsflater, og bruk tynne sammenhengende webber mellom kontrollpunktene. Ikke bruk denne metoden for styrke-, last-, varme- eller endelig materialklareringstest.

## Nyttige kommandoer

```bash
cd projects/02-21ft-rib-trailer
./build.sh --approved
python3 scripts/build_fit_test_plate.py
python3 scripts/build_plate_3mf.py
python3 scripts/build_remaining_after_trial.py
scripts/check_joint_interfaces.sh
```

Se `3mf/fit_tests/README.md`, `3mf/remaining_after_trial/README.md` og hoved-README for nøyaktig plateinnhold og monteringsinstruksjoner.
