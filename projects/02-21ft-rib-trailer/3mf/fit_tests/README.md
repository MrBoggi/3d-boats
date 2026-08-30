# Skjøte- og koblingstest

> **FORELDET 2026-08-30:** Rammedelen av denne pakken bruker tidligere løse
> skjøteplater. Bruk `../integrated_joint_tests/integrated_frame_joint_test.3mf`
> for den reviderte rammen.

Print og godkjenn denne pakken før `remaining_after_trial` brukes. Kupongene er fullskala utsnitt av produksjonsgeometrien; hull, anleggsflater og klaringer er identiske. Bruk faktiske M3-skruer, skiver og muttere under kontrollen.

Godkjenn: fri innføring uten tvang, ingen synlig vridning, gjennomgående hull som flukter, plater som ligger plant, og fri vipping i begge siderulleledd.

## Monteringskontroll

1. Monter `fit_v_front` mot `fit_v_rear` med to M3-bolter. Halvdelene skal gli helt sammen uten bøying eller filing.
2. Før tungen på `coupler_mount_adapter` inn i `fit_coupler_frame` og monter begge M3-boltene. Begge hull skal være helt gjennomgående.
3. Legg `fit_splice_front` og `fit_splice_rear` ende mot ende og monter `splice_plate` på utsiden.
4. Monter `fit_mid_rail` mot `fit_mid_crossmember` med én `crossmember_joint_plate_mid` over og én under. Platene skal ligge plant.
5. Gjenta med `fit_rear_rail`, `fit_rear_crossmember` og de to bakre skjøteplatene.
6. Monter `fit_side_post_head` mellom hovedørene på `side_double_roller_cradle`. Monter deretter `side_roller_wobble_holder` rundt én av de små knastene. Begge ledd skal vippe fritt uten merkbar slark eller gnissing.

Stopp videre produksjonsprint ved feil. Mål avviket med skyvelære og korriger den delte parameteren i `config.scad`; ikke fil til testdelen passer og deretter anta at produksjonsdelen er riktig.

## Plateinnhold

A1, 256 × 256 mm. Antallene dekker én komplett henger.
Prosjektfilene inneholder totalt 1 fysiske platefaner.

## fit_test_plate_01.3mf

Fysiske platefaner: 1

- `coupler_mount_adapter` × 1
- `crossmember_joint_plate_mid` × 2
- `crossmember_joint_plate_rear` × 2
- `fit_coupler_frame` × 1
- `fit_mid_crossmember` × 1
- `fit_mid_rail` × 1
- `fit_rear_crossmember` × 1
- `fit_rear_rail` × 1
- `fit_side_post_head` × 1
- `fit_splice_front` × 1
- `fit_splice_rear` × 1
- `fit_v_front` × 1
- `fit_v_rear` × 1
- `side_double_roller_cradle` × 1
- `side_roller_wobble_holder` × 1
- `splice_plate` × 1
