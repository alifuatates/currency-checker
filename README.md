currency-checker
================

## SCRIPT E PARAMETRE GEÇME

currency_convert.sh bash scripti çalıştırılırken kullanıcıdan 3 tane parametre irmesin bekliyor. Bu yüzden fonksiyonun kullanıcı parametrelerini alması için bir yöntem kullandım.
Bash scriptine geçilen parametreleri okuyabilmek için bash scripte özel keyword kullandım. Çalışma şekli şu şekilde;

$0 => bash scriptin adını verir (currency_convert.sh)

$1 => scripte geçilen 1. parametreyi verir (Mesela USD)

$2 => scripte geçilen 2. parametreyi verir (Mesela TRY)

$3 => scripte geçilen 3. parametreyi verir (Mesela 2)

$4, $5, ....., $n bu şekilde girilen parametrelerin sırasına göre scriptin içinden bu prametreler okunup kullanılabilir 

Scriptteki kullanım şekli;
```bash
FROM_CURRENCY="$1"
TO_CURRENCY="$2"
AMOUNT="$3"
```
Detaylı bilgi için http://how-to.wikia.com/wiki/How_to_read_command_line_arguments_in_a_bash_script

## KONTROL YAPILARI

Yazdığım scriptte şu kontroller sağlanıyor;

a. Kullanıcının 3 gerekli olan 3 tane parametreyi girip girmediğini kontrol etme

b. Çevrilmek istenen kurun belirli bir limitin üstünde olması halinde kullanıcıya mail gönderiliyor. Bu limiti kontrol etme

Scriptteki kula-lanım şekli
```bash
if [[ "$#" -ne 3 ]]; then
	echo "Lütfen parametreli eksiksiz girin"
else
	#diğer işlemler
fi
```
Burada if içinde yine bash scripte özel "-ne" ifadesini kullandım. Yani "Not Equal". Buna benzer başka ifadeler ise;

gt => "Greater Than"

lt => "Less Than"

gibi...

Burada kullanıcının kaç tane parametre girdiğini tespit etmek için bash scripte özel keyword olan "$#" ı kullandım. Bash scriptte kontrol yapılarındaki ifadelerin bitiş yerini belirtmek 
için, ifadenin tersi kullanılır. Örnek;

if 
...
fi

case
....
esac   gibi...

Daha fazla bilgi için şuraya göz atabilirsiniz http://cecs.wright.edu/~pmateti/Courses/333/Notes/bash-control_s.html

## SED

SED = Stream EDitor. 1970 li yıllarda yazılan bu fonksiyon, bir çok yerde hayat kurtarır. Genel olarak dosyadan ya da başka bir kaynaktan gelen veri üzerinde metin dönüştürmesini sağlar.

Örnek kullanım;
```bash
echo Alifuat SU | sed 's/SU/ATEŞ/'
```
Yukarıdaki ifadede, Alifuat SU metni Alifuat ATEŞ ifadesine dönüştürülür. Bunusağlayan ise, 's/SU/ATEŞ/' kısmıdır. Detaylı bilgi için bu adrese bakabilir http://www.grymoire.com/Unix/Sed.html ya da linux komut satırında "man sendmail" yazıp nasıl kullanıldığı hakkında bilgi alabilirsiniz.

## REGULAR EXPRESSIONS

Düzenli ifadeler birçok programlama dillerinde olduğu gibi bash script programlamada da kullanılmaktadır. Kısaca, veri filtrelemede, validasyonda, ya da metin dönüştürmelerinde kullanılır.
Mesela Kullanıcı kayıt sistemini düşünün. Burada kullanıcıdan beklenen değerlerin içinde email yer almaktadır. Kullanıcının girdiği email adresinin geçerli bir adres olup olmadığını tespit
etmek için bir filtreleme mekanizmasına ihtiyaç duyarız. Email validasyonu için aşağıdaki ifade kullanılabilir;
```bash
^[\w-\._\+%]+@(?:[\w-]+\.)+[\w]{2,6}$
```
Benim yaptığım programda kullanma ihtiyacım şu şekilde oldu. Kur dönüşümü için kullandığım servis bana JSON tipinde bir data döndürüyor. Dönen datada "v" adında bir anahtara ait değeri almaya çalışıyorum. Onun içinde şöyle bir ifade kullandım.
```bash
v\":(.*)
```
Yani v": yi görünce, bu anahtardan sonraki değeri almasını sağlıyorum.

Bu konuda daha fazla bilgi almak ve örnek düzenli ifadelere ulaşmak için buraya bakabilirsiniz. http://gskinner.com/RegExr/

## EMAILING

Bu scriptin temel amaclarından biri de döviz bilgisinin belirli bir değere ulaşması halinde kullanıcıya email göndermesidir. Servisten dönden değeri filtreleyip istenilen değeri bulduktan sonra kontrol yapılarını kullanarak değerin belirli bir limitten yüksek olup olmmamasıı kontrol ediyorum. Eğer limiti aşmışsa, belirtilen kullanıcıya email gönderiyorum. Örnek kullanım;
```bash
subject="Dolar 2 liranın üzerine çıktı"		
recipients="alifuatates36@gmail.com"
from="info@currencyservice.com"
mail="subject:$subject\nfrom:$from\n$subject"
echo -e $mail | /usr/sbin/sendmail "$recipients"
```
Burada ilk önce Subject, Alıcı, Gönderici ve Mesaj kısmnı tanımlayıp, sonra sendmail i kullanarak kullanıcıya mail gönderiyorum. Sendmail ile ilgili detaylı bilgiye buradan ulaşabilirsiniz.
http://www.sendmail.com/sm/open_source/

>Önemli Not: Scriptin email gönderebilmesi için, scriptin çalıştırıldığı makinede sendmail kurulu olması lazım. 

Bu scripti best practise olması açısından crontab e koydup dakikada bir çalışmasını sağladım. Bu sayede bu script her dakika döviz servisini çağırıp, belirtilen kur değerini alıp kullancıya mail atmasını sağlıyorum. Crontab için gerekli satır ise şu şekilde;
```bash
* * * * * scriptin_bulunduğu_dizin/currency_convert.sh USD TRY 1
```
Crontab hakkında detaylı bilgi için ise şuraya göz atabilirsiniz. http://kvz.io/blog/2007/07/29/schedule-tasks-on-linux-using-crontab/







