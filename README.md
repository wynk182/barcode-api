## Data Encoder API

Generate Barcodes and QR codes in bulk. Supports a variety of encoding formats.

---

### Encoding types

| Type                                                                        | Parameter             |
| --------------------------------------------------------------------------- | --------------------- |
| [QR code](https://en.wikipedia.org/wiki/QR_code)                            | `qr_code`             |
| [Code 128A](https://en.wikipedia.org/wiki/Code_128)                         | `code_128a`           |
| [Code 128B](https://en.wikipedia.org/wiki/Code_128)                         | `code_128b`           |
| [Code 128C](https://en.wikipedia.org/wiki/Code_128)                         | `code_128c`           |
| [Code 25](https://en.wikipedia.org/wiki/Industrial_2_of_5)                  | `code_25`             |
| [Code 25 Interleaved](https://en.wikipedia.org/wiki/Interleaved_2_of_5)     | `code_25_interleaved` |
| [Code 25 IATA](https://en.wikipedia.org/wiki/Industrial_2_of_5#IATA_2_of_5) | `code_25_iata`        |
| [Code 39](https://en.wikipedia.org/wiki/Code_39)                            | `code_39`             |
| [Code 93](https://en.wikipedia.org/wiki/Code_93)                            | `code_93`             |
| [GS1 128](https://en.wikipedia.org/wiki/GS1-128)                            | `gs1_128`             |
| [EAN-13](https://en.wikipedia.org/wiki/International_Article_Number)        | `ean_13`              |
| [Bookland](https://en.wikipedia.org/wiki/Bookland)                          | `bookland`            |
| [EAN-8](https://en.wikipedia.org/wiki/EAN-8)                                | `ean_8`               |
| [UPC/EAN supplemental, 2 & 5 digits]()                                      | `upc_supplemental`    |
| [Codabar](https://en.wikipedia.org/wiki/Codabar)                            | `codabar`             |

## Output Format

---

By default the api will respond with a base 64 encoded `png` and will contain `data:image/png;base64,` prepended. To request raw `png` base 64 data the value `raw_base_64` can be passed as the format parameter.

---

### Other supported format paramters

| Format          | Parameter     |
| --------------- | ------------- |
| PNG             | `png`         |
| Raw PNG base 64 | `raw_base_64` |
| HTML            | `html`        |
| SVG             | `svg`         |

---

## Example Request

```curl
curl "https://www.wynk182.com/encoded/api" \
  -X POST \
  -d "{\"codes\": [{\"type\": \"qr_code\",\"data\": \"https://www.wynk182.com\", \"size\": 5}]}" \
  -H "x-encoded-api-key: 493dba15e4cf09536084e337cb5ad55dc3123f9b10b6978246e3e2444f3b60b61ec9e01481de5e16beb21fb3ff6ef2adef30f7747997a727ad0b3eb695f51e65" \
  -H "content-type: application/json"
```

## Example Response

```json
[
  {
    "png": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAC0AAAAtAQAAAAASYd83AAAAm0lEQVR4nGP6DwI/mBjAgHzqYO5EBSAlz8J+AEh9urq3ASQn5wBWIgJWwveDGST48NlOByBln7/+AZA66scBEuRsvJAApMSq34DkPp0RWQCk3jqtBimxWRMCErzv0Aui2GougeTeP/MG8XQLY0C8g8U7QDbIfzkB1s6VAnIEgyoHSDvDg6sgo/l+bwfxHvIeB1H2y54kUOBbMAAAw7s3TiFroBUAAAAASUVORK5CYII=",
    "data": "https://www.wynk182.com",
    "format": "png",
    "type": "qr_code"
  }
]
```

### Add barcode to a webpage
```html
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAC0AAAAtAQAAAAASYd83AAAAm0lEQVR4nGP6DwI/mBjAgHzqYO5EBSAlz8J+AEh9urq3ASQn5wBWIgJWwveDGST48NlOByBln7/+AZA66scBEuRsvJAApMSq34DkPp0RWQCk3jqtBimxWRMCErzv0Aui2GougeTeP/MG8XQLY0C8g8U7QDbIfzkB1s6VAnIEgyoHSDvDg6sgo/l+bwfxHvIeB1H2y54kUOBbMAAAw7s3TiFroBUAAAAASUVORK5CYII=" width="100px" height="100px" />
```