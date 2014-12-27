# Gdexpress API Client

Un _wrapper_ básico para la API de [Gdexpress](http://gdexpress.cl/)

**Gdexpress** es un servicio de emisión de Documentos Tributarios Electrónicos, ```DTE```, para Chile: [Facturación Electrónica en Chile](https://palena.sii.cl/dte/menu.html)


## Requisitos

* Ruby 1.9.3 o mayor,
* Tener una cuenta con [Gdexpress](http://gdexpress.cl/)

## Instalación

Agrega esto a tu archivo Gemfile:

    gem 'gdexpress'

y luego ejecuta:

    $ bundle

O instalalo tu mismo:

    $ gem install gdexpress

## Uso

```ruby
 # api_token: el código de autorización entregado por el dte_box
 # dte_box: es la IP del servidor instalado por gdexpress
 # environment: es el ambiente: testing o producction
 gd_client = Gdexpress::Client.new( 
				api_token: "123456",
				dte_box: "192.168.0.1",
				environment: :testing
			)
 # dte es un objecto que responde a los siguentes métodos:
 # rut_emisor: RUT de empresa que emite el DTE,
 # tipo_dte: mirar http://www.sii.cl/factura_electronica/formato_dte.pdf
 # folio: número del DTE
 dte = OpenStruct.new rut_emisor: 11111111-1, tipo_dte: 33, folio: 28
 
 # Revisa si el documento fue procesado por el SII
 # Devuelve true o false
 gd_client.processed? dte

 # Revisa si el documento fue aceptado por el SII
 # Devuelve true o false
 gd_client.accepted? dte
 
 # Devuelve XML con el tracking del documento
 gd_client.tracking dte
 
 # Devuelve XML del DTE
 gd_client.recover_xml dte
 
 # Devuelve string base64 que representa el PDF del DTE
 pdf64= gd_client.recover_pdf_base64 dte
 
 # Decodificas de base64
 pdf = Base64.decode64(pdf64)
 
 # Creas el archivo PDF
 File.open("/tmp/pdf.pdf", 'wb') do |f|
   f.write pdf
 end

```

## Contribuye

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Copyright
Copyright 2014 IT Linux LTDA.
GdExpress es una marca registrada de GDE S.A.

Licensed under the MIT License, you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://opensource.org/licenses/MIT

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

