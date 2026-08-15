# Båthenger for 21 ft RIB — designplan

Parametrisk boggihenger i skala 1:10, utviklet for båten i
[`../01-21ft-rib`](../01-21ft-rib/README.md). Hengeren skal kunne vises sammen
med båten, skrives ut på Bambu Lab A1 og bygges som en funksjonell RC-modell
med roterende hjul, vippbar boggi og justerbare skrogstøtter.

## Status

Detaljert digital review-versjon er implementert. Den inneholder komplett
sammenstilling, direkte skrogreferanse fra prosjekt 01 og 32 separate
eksportmål. En forstørret todelt V-front, rammeskjøter, tverrbjelkefester,
boggi-endestopp, M4-hjulaksler, synlige M4-muttere og separate 12 mm sekskantadaptere med avstandshylse,
justerbare støtter og en fremoverlent, avstivet vinsjstolpe med V-stopp på båtsiden er modellert. Modellen er kontrollert
med OpenSCAD, men ikke fysisk printet eller verifisert.

## Kjøpt RC-kobling

[AliExpress-produkt 1005005631960547](https://www.aliexpress.com/item/1005005631960547.html) er et AJRC justerbart `drop hitch receiver` for bilsiden på 1:10-crawlere som TRX-4 og SCX10. På hengeren trengs den matchende metallkloen, ikke en kopi av bilfestet.

CAD-en bruker den vanligste dokumenterte 1:10-standarden:

- 5,8–6,0 mm kule på trekkbilen;
- trailerklør for 6 mm kule;
- omtrent 35 mm lang metallklo;
- M3-gjenget sokkel i bakkant av kloen;
- 9 mm M3-stud ut fra hengeradapteren.

Et dokumentert eksempel er [Absima 2320126](https://rcmodelshopdirect.com/shop/accessories/rc-crawler-accessories/absima-1-10th-trailer-hitch-2320126/), som oppgir 35 mm lengde, M3-sokkel og 6 mm kule. Kompatible 6 mm kulefester finnes også fra [Integy](https://integy.shop/products/rock-crawlers-hop-up-parts-c33970). Produktet og AliExpress-variantene er `example`, ikke fysisk testet. Kontroller at valgt bilfeste leveres med 5,8–6 mm kule, og kjøp en trailerklør med M3-sokkel hvis den ikke følger med.

Hengeren har en separat printet frontadapter. Den overlapper senterbjelken 18 mm og festes med to vertikale M3-bolter. En fanget aksial M3-skrue gir 9 mm gjengestud til metallkloen. Adapteren kan dermed endres senere uten å printe V-draget på nytt.

## Visuelle referanser

Utformingen følger vanlige radius-toppskjermer for tandemakslede båthengere,
brede rektangulære LED-baklys og Y-/V-formede baugstopp på vinsjstolpen:

- [Tandemskjermer – BoatTrailerParts](https://www.boattrailerparts.com/Tandem-Axle-Boat-Trailer-Fenders_c_85.html)
- [Skrå vinsjstolpe med avstiving – BoatTrailerParts](https://www.boattrailerparts.com/Boat-Trailer-Winch-Post-Angled-3-inch-x-3-inch-x-24-inch-Tall-Galvanized_p_1960.html)
- [45° justerbar vinsjstolpe – etrailer](https://www.etrailer.com/search/Bow%2Bstop%2Bpost)
- [Plassering av baugstopp – etrailer](https://www.etrailer.com/faq-4-choices-buying-a-boat-trailer.aspx)
- [Rektangulære båthengerlys – EZ Loader](https://ezloadertrailers.com/products/ez-loader-updated-taillight-set-7-5-x-3-5-411-3002)

Referansene angir form og plassering; komponentene i CAD er egne skalerte
printdeler og er ikke fysisk testet.

## Grunnlag fra prosjekt 01

| Egenskap | Verdi |
|---|---:|
| Skala | 1:10 |
| Båtlengde | 660 mm |
| Maksimal båtbredde | 252 mm |
| Skrogtype | V-bunn, 26° referanse-deadrise, integrerte pongtonger |
| Båtens koordinater | X baug→hekk, Y babord→styrbord, Z kjøl→opp |
| Målskriver | Bambu Lab A1, 256 × 256 × 256 mm |

Hengermodellen skal importere eller gjengi skrogets kontaktprofil fra prosjekt
01. Parallelle, manuelt kopierte skrogmål skal unngås.

## Foreslått hovedkonsept

- Sveiset stålramme gjengitt som en modulær, printet kanal-/boksramme.
- A-ramme i front med kulekobling, langsgående 12 × 18 mm senterbjelke og fremoverlent vinsjtårn med doble skråstag på framsiden.
- V-baugstoppen står på båtsiden av vinsjtrommelen, slik at skroget stoppes før det kan nå trommel eller sveiv.
- To langsgående hovedvanger med tverrbjelker og separate skjøtestykker.
- Tandemakslet boggi på hver side. Hver boggi vipper rundt ett sentralt lagerpunkt,
  slik at begge hjul kan følge underlaget.
- Fire kjølruller langs senterlinjen tar hovedvekten.
- To par justerbare dobbeltrullestøtter støtter V-bunnen uten å belaste pongtongene.
- Motorens senterlinje holdes åpen bak X = 585 mm; forstørrede baklys og skilt sitter på bjelken foran.
- Én lang, buet tandemskjerm per side dekker begge hjul og festes med separate M3-braketter.
- En utskiftbar V-formet baugstopp i TPU sitter over vinsjtrommelen og tar imot V-baugen uten å bære skrogvekten.
- Baugstøtte og vinsjtrommel låser båten i lengderetningen. En egen akterstropp
  reserveres i modellen.

## Foreløpig dimensjoneringskonvolutt

| Parameter | Startverdi | Begrunnelse |
|---|---:|---|
| Total lengde | 800 mm | 660 mm båt, drag og klaring ved hekk |
| Ramme fra baugstøtte til akterende | 700 mm | Full understøttelse av skroget |
| Ytre rammebredde | 220 mm | Under båtens 252 mm maks. bredde |
| Sporvidde, hjulsenter | 290 mm | Klaring utenfor pongtongene |
| Maksimal totalbredde | 317 mm | Foreløpig hjul-/skjermkonvolutt |
| Hjuldiameter / reservert bredde | 65 / 27 mm | AliExpress-hjul; bredde må kontrollmåles |
| Hjulaksel | M4 × 55 mm | Ø4,3 mm klaringshull og fanget skruehode |
| Akselavstand i boggi | 78 mm | Klaring mellom 65 mm hjul |
| Bakkeklaring under ramme | 22 mm | Funksjonell modell på jevnt underlag |
| Klaring mellom skrog og hard støtte | 1.0 mm | Plass til myke støtteflater |
| Boggiens vinkelutslag | ±12° | Terrengbevegelse uten kontakt med ramme |

Valgt eksempel er [AliExpress-produkt 1005009693636383](https://www.aliexpress.com/item/1005009693636383.html), oppgitt som ARRMA
ARA550116-kompatibelt hjul med diameter 65 mm og 12 mm sekskantfeste. CAD-en
reserverer 27 mm hjulbredde inntil et fysisk hjul kan måles. Hvert hjul monteres med en separat printet sekskantadapter med integrert
avstandshylse, M4 × 55 mm skrue, to skiver og M4 låsemutter. Skrue, skiver
og mutter vises nå også i normal `assembly`, mens klaringsvolumene fortsatt
styres av `show_hardware`. Adapteren er 11,5 mm over flatene for 0,25 mm klaring per side.
Produktet er foreløpig et eksempel, ikke fysisk testet. ARRMA oppgir 12 mm
sekskantfeste for ARA550116, og det tilhørende GROM-akselsettet ARA311231
bruker M4-hjulmuttere: [hjuldata](https://www.arrma-rc.com/en/product/arrma-dboots-fortress-tire-set-glued-red-2-pairs/ARA550116.html) og
[akseldata](https://www.arrma-rc.com/de/product/arrma-metal-axle-and-wheel-hex-set-b-4-grom/ARA311231.html).

Alle startverdier skal ligge i `scad/config.scad` og kunne justeres etter første
digital prøvepass. Totalbredden er større enn byggeplaten, så aksler,
boggiarmer og hjul må være separate deler.

## Designfaser

### 1. Lås båtens plassering og kontaktpunkter

Plasser båten med samme X/Y/Z-retning som i prosjekt 01. Definer et eget
`boat_reference`-oppsett med:

- kjølens høyde langs X;
- V-bunnens høyde ved valgte støttebredder;
- maksimal pongtongkonvolutt;
- motorens og akterspeilets frie område;
- båtens tyngdepunkt som en justerbar antakelse frem til det måles fysisk.

Første mål er minst 5 mm fri avstand mellom hard hengerramme og skrog/pongtong
ved nominell plassering.

### 2. Lag en enkel layoutmodell

Modeller først bare klaringsvolumer for båt, hjul, aksler, kobling og
vinsjtårn. Kontroller ovenfra og fra siden at:

- båten er sentrert og ikke treffer skjermer eller vinsjtårn;
- akterspeil og påhengsmotor har fri passasje gjennom den åpne akterenden;
- estimert tyngdepunkt ligger litt foran boggisenteret;
- kulekoblingen får tilstrekkelig sving- og høydeklaring.

### 3. Dimensjoner ramme og utskriftsdeling

De parallelle hovedvangene starter ved X = 276 mm, direkte mot bakkanten av tverrbjelken ved X = 270 mm, og deles ved X = 440 mm.
Fronten er en stor V fra koblingen ved X = -108 mm til vangene ved X = 270 mm.
V-en deles ved X = 60 mm med 10 mm overlapp og gjennomgående M3-skruer. Tverrbjelkene skal være separate slik at samlet bredde ikke bestemmer
utskriftsretningen. Legg mest materiale rundt boggifeste, vinsjtårn og skjøter.

### 4. Utvikle boggien som egen mekanisme

Hver side får én vippende boggiarm med to separate hjulaksler. Reserver først
hardware-konvolutter for M4 × 55 mm hjulskruer, skiver, låsemuttere og
separate 12 mm sekskantadaptere. Boggiens senterbolt skal være tilgjengelig uten å demontere rammen.
Mekaniske endestopp begrenser vinkelutslaget og hindrer at dekk treffer rammen.

### 5. Tilpass kjølruller og sidestøtter

Plasser kjølruller ved omtrent X = 110, 270, 430 og 585 mm i båtens koordinater,
og finjuster dem mot den faktiske kjølkurven. Sidestøttene plasseres parvis nær
de to midtre/akterste sonene, med vinkel bestemt av skrogets lokale V-flate.
Støttehodene skal være utskiftbare og ha flater for TPU-, filt- eller
gummibelegg. Pongtongene skal ikke være lastbærende.

### 6. Legg til opptrekk og sikring

Vinsjtårnet heller omtrent 29° fremover fra vertikalen. Den brede fotplaten er erstattet av en 12 × 18 mm senterbjelke fra V-spissen til tverrbjelken ved X = 34 mm. Stolpefoten står direkte på dette krysningspunktet med gjennomgående M3-feste, mens to diagonaler lander på senterbjelken foran. Baugstoppen er en separat, kompakt TPU-V mellom to faste gaffelører på båtsiden av trommelen. En gjennomgående M3-pivot med 0,4 mm sideklaring, skiver og låsemutter lar hele V-klossen selvjustere opptil ±15° i lengderetningen,
og vinsjen får gjennomgående aksel og håndsveiv. Modellen reserverer føring for
line, sikkerhetskjetting og stroppepunkter ved akterenden. Dette modelleres etter
at båtens hvilestilling er låst.

### 7. Verifiser og iterer

Lag først små prøveutskrifter av rammeskjøt, boggilager, hjuladapter og én
skrogstøtte. Deretter:

1. Render alle deler enkeltvis og som komplett henger.
2. Render en debug-sammenstilling med båt og alle hardware-konvolutter.
3. Kontroller manifold geometri og byggevolum for hver eksport.
4. Print én boggi og test vipping, hjulfrigang og skrueadkomst.
5. Print en kort rammeseksjon med støtte og fysisk prøv mot skroget.
6. Monter full ramme, juster støttehøyder og mål faktisk kuletrykk.
7. Lås parametere først etter rulle-, sving- og lastetest med den ferdige båten.

## Filstruktur

```text
02-21ft-rib-trailer/
├── README.md
├── build.sh
├── scad/
│   ├── config.scad
│   ├── hardware.scad
│   ├── boat_reference.scad
│   ├── frame.scad
│   ├── bogie.scad
│   ├── fenders.scad
│   ├── coupler.scad
│   ├── supports.scad
│   ├── winch.scad
│   └── assembly.scad
├── stl/
├── 3mf/
└── png/
```

`assembly.scad` har en `selected_part`-velger for hver printdel. Variablene
`show_boat`, `show_outboard`, `show_road` og `show_hardware` styrer henholdsvis
skrogreferansen, den komplette motorreferansen, veireferansen ved Z = 0 og
hardware-konvoluttene. `show_keel_contact_debug=true` legger fire
ugjennomsiktige turkise skrogsnitt over kjølrullene, slik at anlegget kan
vurderes uten transparent-overlapping.
Motoren gjenbrukes fra båtprosjektets originalmodell med original kort stamme
og motorfeste. XL-avstandsstykket er ikke med i trailervisningen. Motoren vises
uten tilt, slik at akter- og propellklaringen kan vurderes mot veien.

## Bygg og forhåndsvisning

Åpne hele sammenstillingen med båten:

```sh
openscad scad/assembly.scad
```

Eksporter én del, for eksempel boggiarmen:

```sh
openscad -o bogie_arm.stl \
  -D 'selected_part="bogie_arm"' \
  -D 'show_boat=false' \
  scad/assembly.scad
```

Etter visuell godkjenning eksporteres hele settet og tre PNG-visninger med:

```sh
./build.sh --approved
```

## Implementerte printmål

- Ett 164 mm midtsegment og ett 145 mm aktersegment per hovedvange; begge slutter ved X = 585 mm.
- Fire utvendige skjøtelasker rundt vangskjøten ved X = 440 mm.
- To standardtverrbjelker ved X = 270 og 430 mm og én tilpasset lysbjelke ved X = 585 mm. Den tidligere tverrbjelken i vangskjøten ved X = 440 mm er fjernet, slik at skjøteboltene ikke ligger i en delesøm.
- V-bakdelen stopper plant ved forkanten av tverrbjelken ved X = 270 mm, og hovedvangene starter ved bakkanten. Fire identiske 3 mm skjøteplater, én over og én under på hver side, forbinder V-arm, tverrbjelke og hovedvange med tre M3-bolter per side.
- Todelt, forstørret V-front med to M3-bolter per arm i skjøten, integrerte broer og langsgående senterbjelke frem til vinsjtverrbjelken.
- Separat frontadapter med 18 mm overlapp, to M3-rammebolter og aksial M3-stud for kjøpt 6 mm trailerklør.
- To boggiarmer og to åpne clevisfester med 4 mm inner-/ytterører, 1,2 mm lagergap, 0,8 mm skiver og fanget M3-mutter. Hvert feste har toppflens og to vertikale M3-bolter gjennom hovedvangen; endestoppene gir verifisert ±12° utslag.
- Fire separate PETG/ASA-sekskantadaptere for kjøpehjul med 12 mm feste og integrert Ø10 mm avstandshylse.
- Alle bærende rammebjelker har 12 × 18 mm profil, slik at V-front, hovedvanger og tverrbjelker møtes med plane over- og undersider uten påbygde kiler.
- Fire kjølruller og åtte separate, speilbare sidebraketter som står på oversiden av V-broen eller tverrbjelken og festes i samsvarende M3-hull. Rullene har en konkav 26° V-profil, Ø7 mm i senter og Ø23 mm ved endene. Holderne består av to speilbare, separate sidebraketter per rull, er åpne under rullens rotasjonsbane og har sideføtter, 1 mm aksial endeklaring og minst 0,4 mm radial klaring over bjelken. Båtens referansehøyde er løftet 6 mm for å gi plass til den reelle V-rullekonvolutten. Akselhøydene er avledet fra skrogets målte kjølhøyde ved hver stasjon og gir minst 0,3 mm digital klaring til den analytiske V-bunnen.
- Fire støttehylser med bolteflens mot tverrbjelkene, fire justerbare poster, fire bolteforbundne rulleåk og åtte separate sideruller. Hver siderulle sitter i en separat wobble-holder med M3-sekundærpivot rundt X-aksen, ±10° mekanisk utslag og fysiske endestopp. Hovedåket har Y-pivot mot støtteposten og skrogavledet lengdevipp på ca. -3,0° foran og -0,04° bak. Siderullene har en svakt konveks TPU-profil, Ø16 mm i midten og Ø13 mm ved endene, for å redusere kantkontakt.
- Fremoverlent vinsjstolpe uten bred fotplate; stolpefoten treffer vinsjtverrbjelken direkte, og doble frontstag treffer senterbjelken med hvert sitt M3-feste. Trommel, sveiv og boltet V-baugstopp på båtsiden er separate deler.
- To forstørrede lyktehus ved Y = ±106 mm, to røde linser med to demonterbare M2-fester hver og én sideforskjøvet skiltplate.
- To buede tandemskjermer med lukket, ringformet innerkant og åpne hjulflater. Midtbrakettene er flyttet opp på clevisenes toppbro og boltes vertikalt der, slik at armkanal og hovedvange holdes fri.
- V-formet, boltet og kompakt baugstopp med 18 mm spenn som separat TPU-del.
- Ingen tverrbjelke ved X = 652 mm; motorens bakre klaringssone er åpen.

Støttehjul, innføringsruller og stroppeører er ikke med i denne
review-versjonen.

## Printorientering

| Del | Anbefalt orientering |
|---|---|
| Koblingsadapter | Største flate ned; test M3-stud før full montering |
| V-frontseksjoner | Største flate mot byggeplaten |
| Hovedvanger og tverrbjelker | Største flate mot byggeplaten |
| Lyktehus, linser og skiltplate | Største flate ned |
| Skjøtelask | Flatt |
| V–vange-skjøteplate | Flatt; print fire identiske |
| Boggiarm | Stor sideflate ned |
| Boggifeste | Rammeanlegget ned |
| Hjuladapter og kjølrulle | Én rund side ned; vurder støtte i navhullet |
| Tandemskjerm | Legg på én langside; støtte under buen kan bli nødvendig |
| Skjermbrakett | Flatt |
| V-baugstopp | Stor sideflate ned, TPU |
| Baugøye (prototype) | Stor monteringsflate ned; metallutførelse eller forsterket PETG/ASA må vurderes |
| Støttehylse og post | Største flate/side ned |
| Rulleåk | Største flate ned |
| Wobble-holder | Største flate ned; print åtte identiske |
| Siderulle | Én rund side ned |
| Vinsjtårn | Fot/anleggsflate ned; lokal støtte kan bli nødvendig |

Alle 32 eksportdeler er eksportert til STL og kontrollmålt fra den faktiske
triangelgeometrien. Samtlige kompilerer som `Simple: yes` og ligger innenfor
256 × 256 × 256 mm. Største todimensjonale fotavtrykk er `drawbar_rear`
på ca. 214 × 217 mm; tverrbjelkene er 220 mm lange. Alle delene er også
slicet digitalt på korrekt A1-plate som beskrevet under.

## Slicer-verifikasjon

Alle 32 STL-er er slicet med Bambu Studio 2.7.1.62 Flatpak mot Bambu Lab A1,
0,4 mm dyse og 0,20 mm Standard. De strukturelle delene ble kontrollert med
Generic PETG; `bow_stop` ble i tillegg kontrollert med Bambu TPU 95A. Alle
deler ble beholdt i dokumentert eksportorientering, med kun platearrangering
og eventuell rotasjon rundt Z-aksen.

Bambu Studio-CLI-en mistet A1-profilens arvede platepolygon og falt tilbake til
200 × 200 mm. `drawbar_rear` og de to 220 mm tverrbjelkene ble derfor også
kontrollert via 3MF med A1-profilens faktiske 256 × 256 mm polygon; alle tre
slicet uten advarsel. Seks deler trenger normal automatisk støtte:

- `coupler_mount_adapter`;
- `side_double_roller_cradle`;
- `side_roller_wobble_holder`;
- `tandem_fender`;
- `wheel_hex_adapter`;
- `winch_tower_body`.

Disse seks ble slicet på nytt med `normal(auto)` støtte og ga generert
støttemateriale uten gjenværende advarsler. Etter clevis-redesignet trenger
også `bogie_mount` automatisk støtte. Den separate TPU-filen for `bow_stop`
bruker også automatisk støtte for å unngå flytende regioner. Automatisk brim var aktivert, men
profilen valgte 0 mm brim for kontrollkjøringene. Standardprofilens to vegger
og 20 % infill dokumenterer bare slicbarhet; endelige styrkeinnstillinger må
fastsettes før fysisk prototype.

Etter clevis-redesignet er `bogie_mount`, `bogie_arm`, `fender_mount_bracket`
og `frame_rail_rear` eksportert på nytt som `Simple: yes` og slicet på nytt
med samme A1/PETG-kontrollprofil; alle fire besto. Den forkortede
`wheel_hex_adapter` ble også eksportert og slicet på nytt uten feil. Komplett
trailer uten båt ble til slutt CGAL-rendret som `Simple: yes`.

## Permanente 3MF-filer

Mappen `3mf/` inneholder én ferdig Bambu Studio-prosjektfil for hver av de 32
unike eksportdelene. Hver fil inneholder én kopi av delen og kan åpnes direkte
i Bambu Studio. Kopiantall velges ved utskrift etter delelisten/monteringen.

Prototypeprofilene er:

- Bambu Lab A1 med 0,4 mm dyse og 0,20 mm laghøyde;
- Generic PETG, 4 vegger, 5 topp- og bunnlag, 35 % gyroid for alle harde deler;
- Bambu TPU 95A, 4 vegger, 5 topp- og bunnlag, 25 % gyroid for `bow_stop`;
- 5 mm ytre brim på høye/smale poster og braketter;
- `normal(auto)` støtte på `coupler_mount_adapter`, `bogie_mount`,
  `side_double_roller_cradle`, `side_roller_wobble_holder`, `tandem_fender`,
  `wheel_hex_adapter`, `winch_tower_body` og TPU-delen `bow_stop`.

Alle 32 pakkede filer er kontrollslicet på A1-plate 256 × 256 mm uten
gjenværende advarsler. Innstillingene er et sterkt utgangspunkt for
prøveutskrift, men er ikke fysisk lasttestet. Kontroller valgt filament og
byggeplate i Bambu Studio før utskrift.

Undermappen `3mf/plates/` inneholder i tillegg ferdig arrangerte prosjekter
med full stykkmengde for én henger: tre PETG-prosjektfiler med totalt 78 printdeler, fordelt av Bambu Studio
over seks fysiske platefaner, og én separat TPU-plate med baugstoppen. `3mf/plates/README.md` viser nøyaktig
innhold på hver plate. Prosjektene genereres reproducerbart med
`scripts/build_plate_3mf.py`; generatoren kontrollerer arkivintegritet, antall
instanser og alle interne objektreferanser.

## Visuell service-review

Service-reviewen er utført med seks fokuserte visninger i `png/review_service_*.png` og gule hardware-akser. Følgende er visuelt tilgjengelig uten modellendring:

- alle fire utvendige hjulmutre;
- høydejustering, hovedpivot og rulleaksler på sidestøttene;
- kjølrulleaksler og deres vertikale brakettfester;
- vinsjtrommelaksel, baugstopperpivot og de vertikale tårn-/stagfestene;
- baklyshus, avtakbare linser og skiltplate fra aktersiden.

Skjermens innerfeste og boggipivoten ligger mellom hjulene og krever minst at
ett hjul tas av for komfortabel verktøytilgang. Hjulmutteren er direkte
tilgjengelig, så denne servicerekkefølgen er mulig.

Den opprinnelige massive boggiblokken er erstattet av en reell clevis med fri
armkanal, to 4 mm ører, 1,2 mm lagergap, 0,8 mm skiver og fanget M3-mutter i
innerøret. En M3 × 18 mm bolt føres inn fra utsiden. Eksakte interseksjoner er
tomme i nøytralstilling og ved ±11°, mens begge mekaniske stoppene får kontakt
ved ±12°. Clevis, pivothardware og fullt hjulsveip er tomme mot skjerm og
skjermbrakett. Skjermbraketten sitter nå separat på clevisens toppbro.

## Monteringsrekkefølge for prototype

1. Print og prøv V–vange-skjøteplaten, skjøtelasken, én sekskantadapter og én boggiarm.
2. Monter V-bakdelen mot forkanten av fremre tverrbjelke, hovedvangene mot bakkanten, og lås knutepunktet med skjøteplater over og under før resten av rammeskjøtene trekkes til.
3. Monter boggifester, boggiarmer og fire hjul; kontroller fritt utslag.
4. Monter kjølruller og sidestøtter uten å stramme endelig.
5. Sett båten på hengeren, juster støttehøydene og sjekk minst 5 mm hardklaring.
6. Plasser vinsjtårn og baugstopp etter båtens faktiske hvilestilling.
7. Mål kuletrykk og flytt boggi eller båt før parameterne låses.

## Material- og hardware-retning

PETG eller ASA er utgangspunkt for ramme og mekaniske deler; TPU er aktuelt for
dekk og myke ruller. Endelig hardware velges etter prøvegeometri. Hjulene bruker M4-festemidler; øvrige boggipivoter, rammeskjøter og justerbare
støtter bruker foreløpig M3. Ingen
gjenger modelleres direkte; bruk klaringshull, mutterlommer eller varmeinnsatser.

| Komponent | Status | Reservert CAD-konvolutt |
|---|---|---:|
| 6 mm RC-kule på bil | example | Matchende trailerklør kreves |
| M3-gjenget trailerklør | required | Ca. 35 mm; for 5,8–6,0 mm kule |
| Printet koblingsadapter | required | 32 × 24 × 14 mm + 18 mm tunge; 2 × M3 rammefeste |
| M4 × 55 mm hjulskrue | required | Ø4,3 mm klaringshull; fanget 7 mm skruehode |
| M4 skiver og låsemutter | required | 2 skiver per hjul; mutter 7 mm AF × 4 mm |
| Printet hjuladapter | required | 11,5 mm AF hex × 5,5 mm; Ø18 × 2 mm flens; Ø10 × 6,5 mm hylse |
| [AliExpress 1005009693636383](https://www.aliexpress.com/item/1005009693636383.html) | example | Ø65 × reservert 27 mm; 12 mm hex |
| M3 × 18 mm boggipivot | required | Ø3,4 mm klaringshull; 2 × Ø7/0,8 mm skiver; fanget 5,5 mm AF låsemutter |
| M3 rammeskjøt | required | Ø3,4 mm klaringshull |
| M3 boggi-, skjerm-, rulle-, støtte- og vinsjfeste | required | Samsvarende Ø3,4 mm gjennomgående hull |
| M2 linsefeste | required | Ø2,2 mm linseklaring og Ø1,6 mm pilot i lyktehus |
| M3 mutter | example | 6,2 × 5,5 × 2,6 mm |
| Hjulbredde | example | 27 mm CAD-reserve; må kontrollmåles fysisk |
| Mykt rulle-/støttemateriale | required | TPU, filt eller gummi, ikke valgt |
| Baklys/LED | example | Hus 8 × 38 × 20 mm; linse 3 × 34 × 16 mm |
| Tandemskjerm | required | 35 mm bred; lukket ringkant med åpne hjulflater; 11 mm radiell klaring for fullt ±12° boggiutslag, 2 mm aksial klaring; 2,4 mm gods |
| Skjermbrakett | required | To midtbraketter på clevisens toppbro; vertikal M3 i clevis og horisontal M3 i skjerm |
| V-baugstopp | required | Kompakt 20 × 18 mm TPU-V med 4 mm armer og Ø9 × 7 mm pivotboss; mellom to 3 mm gaffelører, 0,4 mm sideklaring og ±15° fritt utslag |
| Baugøye (båtprosjekt) | prototype | Ø10/5 × 3 mm ring på 26° V-sadel; 2 × M2 gjennom skroget og separat innvendig V-backingplate |
| 1:10 vinsjstropp | example | 2,5 mm nominell flat nylonstropp; reservert konvolutt 3,5 × 1 mm med krok opptil 8 × 5 × 3 mm; festet til vinsjtrommelen og kroket gjennom Ø5 mm baugøye |
| Skiltplate | example | 3 × 42 × 16 mm |

## Godkjenningskriterier

- Båten hviler på kjøl og V-bunn uten hard kontakt mot pongtongene.
- Minst 5 mm fri avstand til ramme og minst 2 mm til bevegelige/hjulnære deler.
- Alle fire hjul roterer fritt og begge boggier kan vippe til mekaniske endestopp.
- Påhengsmotor, støtter, skjermer og vinsjtårn kolliderer ikke i bruk.
- Hver printdel passer innenfor 256 × 256 × 256 mm i dokumentert orientering.
- Alle servicebolter og muttere er tilgjengelige etter montering.
- Sammenstillingen kan demonteres uten å bryte limte hovedkomponenter.
- Fysisk lasttest og faktisk kuletrykk er dokumentert før designet merkes ferdig.

## Digital verifikasjon

- [x] Komplett trailer uten båt rendret med CGAL: `Simple: yes`.
- [x] Alle 32 separate eksportmål rendret: `Simple: yes`.
- [x] Faktiske STL-avgrensninger for alle 32 eksportdeler er målt; største
  fotavtrykk er 214 × 217 mm og alle tre akser er under 256 mm.
- [x] Isometrisk PNG oppdatert med den faktiske RIB-referansen.
- [x] Hardware-debug dekker ramme, boggifestebolter, hjul, rullefester og aksler, støtteflenser og pivoter, skjermfester, vinsjstag, baugstopp, lys, linser og skilt.
- [x] Alle åtte sideruller i arbeidsstilling er testet mot detaljert skrogmesh med eksakt CGAL-interseksjon: tomt resultat.
- [x] Boggiens endestopp og skjermradius er beregnet for ±12° utslag med 2 mm ekstra løpeklaring; egen kontrollvisning viser nøytralstilling og begge endestopp.
- [x] Sveipet hjulvolum gjennom hele boggiutslaget er CGAL-testet mot skjerm og brakett: tom interseksjon.
- [x] Hardt vinsjtårn er CGAL-testet mot skroget: tom interseksjon.
- [x] Baugstopperens lokale V-flate er CGAL-testet mot det eksakte 2,8 mm baugskallet gjennom hele -15° til +15° vandringen. Nominell arbeidsvinkel er +10°, med verifisert kontakt og tom gaffelinterseksjon.
- [x] Separat baugøye i båtprosjektet og flat vinsjstropp er modellert; stroppbanen er CGAL-testet mot V-stopper og gaffel med tom interseksjon.
- [x] Maksimal kjøpekonvolutt på 3,5 × 1 mm stropp og 8 × 5 × 3 mm krok er CGAL-testet mot frontmekanismen: tom interseksjon.
- [x] Leverandørmotorens lukkede maksimumskonvolutt på 100 × 70 × 166 mm er CGAL-testet mot vei og trailerens ramme/lysbjelke: begge interseksjoner er tomme.
- [ ] Baugøyets V-sadel, to M2-skroggjennomføringer og innvendige backingplate er modellert; materialvalg, tetting og fysisk lasttest gjenstår.
- [ ] Visuell eier-review av proporsjoner og skrogkontakt.
- [x] Visuell service-review utført med fokuserte bilder; hjul, støtter, vinsj og baklys har identifisert servicetilgang.
- [x] Boggifestet redesignet som clevis med komplett M3 × 18 mm pivot; arm er fri til ±11°, stopper ved ±12°, og clevis/pivot/hjulsveip er tomme mot skjermsystemet.
- [x] Alle 32 permanente 3MF-filer slicet med Bambu Studio 2.7.1.62 for A1/0,4 mm uten advarsler; sju PETG-deler og TPU-baugstoppen bruker normal automatisk støtte.
- [ ] Fysiske testutskrifter av skjøt, hjuladapter, boggi og justerbar støtte.
- [ ] Last-, klarings- og kuletrykktest med ferdig båt.

## Åpne valg etter review

- Fysisk kontrollmål av kjøpehjulets bredde og dybden på 12 mm hex-lommen.
- Type modellkobling og diameter/høyde på trekkpunktet.
- Om vinsjen skal være funksjonell eller primært skalamessig.
- Om ekstra sidemarkeringslys skal inngå i første produksjonsversjon.
- Faktisk vekt og tyngdepunkt for ferdig båt med batteri og motor.
