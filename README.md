## Data Encoder API
Generate Barcodes and QR codes in bulk. Supports a variety of encoding formats.

------
### Encoding types
|Type|Parameter|
|---|---|
|[QR code](https://en.wikipedia.org/wiki/QR_code)|`qr_code`
|[Code 128A](https://en.wikipedia.org/wiki/Code_128)|`code_128a`
|[Code 128B](https://en.wikipedia.org/wiki/Code_128)|`code_128b`
|[Code 128C](https://en.wikipedia.org/wiki/Code_128)|`code_128c`
|[Code 25](https://en.wikipedia.org/wiki/Industrial_2_of_5)|`code_25`
|[Code 25 Interleaved](https://en.wikipedia.org/wiki/Interleaved_2_of_5)|`code_25_interleaved`
|[Code 25 IATA](https://en.wikipedia.org/wiki/Industrial_2_of_5#IATA_2_of_5)|`code_25_iata`
|[Code 39](https://en.wikipedia.org/wiki/Code_39)| `code_39`
|[Code 93](https://en.wikipedia.org/wiki/Code_93)| `code_93`
|[GS1 128](https://en.wikipedia.org/wiki/GS1-128)| `gs1_128`
|[EAN-13](https://en.wikipedia.org/wiki/International_Article_Number)|	`ean_13`
|[Bookland](https://en.wikipedia.org/wiki/Bookland)| `bookland`
|[EAN-8](https://en.wikipedia.org/wiki/EAN-8)| `ean_8`
|[UPC/EAN supplemental, 2 & 5 digits]()| `upc_supplemental`
|[Codabar](https://en.wikipedia.org/wiki/Codabar)|`codabar`

## Output Format
------
The api response will include a `base_64` key that will contain a base 64 encoded barcode. By default the base 64 data will be an encoded `png` and will contain `data:image/png;base64,` prepended. To request raw `png` base 64 data the value `raw` can be passed as the format parameter.

------
### Other supported format paramters

|Format|Parameter
|---|---
|PNG|`png`
|HTML|`html`
|SVG|`svg`