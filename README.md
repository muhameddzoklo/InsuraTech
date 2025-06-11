InsuraTech_RS2
Seminarski rad iz predmeta Razvoj softvera 2
Fakultet informacijskih tehnologija, Mostar

Upute za pokretanje
Klonirajte InsuraTech repozitorij.

Otvorite folder InsuraTech unutar repozitorija.

Locirajte arhivu fit-build-2025-6-9-env.zip.

Iz arhive ekstraktujte .env file u isti folder (./InsuraTech/InsuraTech).

.env mora biti u InsuraTech\InsuraTech folderu!

U folderu InsuraTech\InsuraTech otvorite terminal i pokrenite:

docker compose up --build

Sačekajte da se svi servisi buildaju i pokrenu.

Vratite se u root InsuraTech folder i pronađite arhive:

fit-build-2025-6-11-desktop.zip

fit-build-2025-6-11-mobile.zip

Iz obje arhive uradite extract.
Trebate dobiti dva foldera: Relase i flutter-apk.

Otvorite folder Relase i pokrenite insuratech_desktop.exe.

Otvorite folder flutter-apk.

File app-release.apk prenesite na emulator i sačekajte instalaciju.

Napomena: Ako je aplikacija već bila instalirana na emulatoru, prethodno je deinstalirajte!

Nakon instalacije obje aplikacije, prijavite se koristeći kredencijale niže.

Kredencijali za prijavu
Administrator (desktop aplikacija)
Korisničko ime: desktop

Lozinka: test

Klijent (mobilna aplikacija)
Korisničko ime: mobile

Lozinka: test

PayPal Sandbox kredencijali
Email: sb-o9qtw42053555@personal.example.com

Lozinka: l?J)jJ1P

Plaćanje je omogućeno kada se kreira nova polica na ekranu My Policies
(polica se kreira preko ekrana Packages)

Mikroservis i RabbitMQ
RabbitMQ se koristi za automatsko slanje emailova nakon dodavanja novog uposlenika na desktop aplikaciji (screen Users).
