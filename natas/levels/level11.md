# NATAS Level 11 -> 12


## GOAL
To escape from an insecure search bar to retrieve the password.


## CONTEXT
### 1
Hexadecimal colour encoding is commonly used in HTML and CSS to represent colours using hexadecimal values. A hexadecimal colour begins with # followed by six characters, where each pair represents the intensity of red, green, and blue (RGB) respectively:
```
#RRGGBB
```
Each component ranges from 00 (minimum intensity) to FF (maximum intensity) in hexadecimal notation. 

Since hexadecimal is base-16, the digits go from 0–9 and A–F, where A=10 and F=15. This encoding allows over 16 million possible colour combinations.

### 2
Exclusive OR (XOR) encryption is a simple symmetric encryption technique based on the XOR logical operator. Each byte of the plaintext is combined with a corresponding byte of a secret key using the XOR operation, producing encrypted output that can later be decrypted by applying the same key again. For more information, see 'ADDITIONAL CONTEXT-1'.

XOR encryption is lightweight and easy to implement, which makes it common in basic obfuscation schemes and security challenges. However, its security depends heavily on the secrecy and uniqueness of the key.


## STEPS
http://natas11.natas.labs.overthewire.org/

After entering the username and password, we find an input box that allows us to introduce a hexadecimal colour, letting us change the background colour. We can once again view the source code:

```php
<?

$defaultdata = array( "showpassword"=>"no", "bgcolor"=>"#ffffff");

function xor_encrypt($in) {
    $key = '<censored>';
    $text = $in;
    $outText = '';

    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
        $outText .= $text[$i] ^ $key[$i % strlen($key)];
    }

    return $outText;
}

function loadData($def) {
    global $_COOKIE;
    $mydata = $def;
    if(array_key_exists("data", $_COOKIE)) {
        $tempdata = json_decode(xor_encrypt(base64_decode($_COOKIE["data"])), true);
        if(is_array($tempdata) && array_key_exists("showpassword", $tempdata) && array_key_exists("bgcolor", $tempdata)) {
            if (preg_match('/^#(?:[a-f\d]{6})$/i', $tempdata['bgcolor'])) {
            $mydata['showpassword'] = $tempdata['showpassword'];
            $mydata['bgcolor'] = $tempdata['bgcolor'];
            }
        }
    }
    return $mydata;
}

function saveData($d) {
    setcookie("data", base64_encode(xor_encrypt(json_encode($d))));
}

$data = loadData($defaultdata);

if(array_key_exists("bgcolor",$_REQUEST)) {
    if (preg_match('/^#(?:[a-f\d]{6})$/i', $_REQUEST['bgcolor'])) {
        $data['bgcolor'] = $_REQUEST['bgcolor'];
    }
}

saveData($data);

?>

<h1>natas11</h1>
<div id="content">
<body style="background: <?=$data['bgcolor']?>;">
Cookies are protected with XOR encryption<br/><br/>

<?
if($data["showpassword"] == "yes") {
    print "The password for natas12 is <censored><br>";
}

?>
```

This PHP code stores user settings inside a browser cookie encrypted with a repeating-key XOR cipher. The application defines default values for `showpassword` and `bgcolor`, then loads the user's cookie, decrypts it using the `xor_encrypt()` function, decodes it in Base64 and parses the resulting JSON data. If the cookie contains valid fields and the background color matches the expected hexadecimal format, the values are accepted and applied to the page. The server then saves the updated settings back into the cookie by encoding the data in JSON, encrypting it again with XOR and encoding it in Base64. Finally, if the decrypted cookie contains `showpassword=yes`, the page reveals the password for the next level.

Our objective is to obtain the key and forge our own cookie, containing `showpassword=yes` to retrieve the password. To do so, we will need to run PHP code.

First, we must gather at least one example of a cookies' 'data', which should look something like this:

```php
$data1 = "HmYkBwozJw4WNyAAFyB1VUcqOE1JZjUIBis7ABdmbU1GIjEJAyIxTRg=";
```

Then, we want to decode it with Base64:

```php
$ciphertext = base64_decode($data1);
```

We will also need an example of the plaintext we expect. We know that the cookie includes `showpassword` and `bgcolor` variables. We will need to encode them in JSON, with the values it had when you gathered the cookies' data:

```php
$plaintext = json_encode(array( "showpassword"=>"no", "bgcolor"=>"#ffffff"));
```

To retrieve the key, we must first do an XOR operation involving the ciphertext and plaintext. For this, we will need to edit the `xor_encrypt` function to accept two values, one of which will act as the current key (which we don't know):

```php
function xor_encrypt2($in1, $in2) {
    $outText = '';

    // Iterate through each character
    for($i=0;$i<strlen($in1);$i++) {
        $outText .= $in1[$i] ^ $in2[$i % strlen($in2)];
    }

    return $outText;
}

$keystream = xor_encrypt2($ciphertext, $plaintext) 
# p ^ k = c and p ^ k ^ p = k, so c ^ p = k
```

Note that the result is not exactly the key. This is because the original encryption used a short key repeatedly iterating through each character, so the real key is the shortest substring that repeats throughout the keystream:

```php
echo $keystream
# For example, if keystream is eXaMeXaMeXaMeXaMeXaMeXaMeXaMeXaMeXaMeXaM, the key would be eXaM
```

With this key, we should be able to forge our own cookie by following the original code followed:

```php
# Orginal encryption
function xor_encrypt($in) {
    $key = <retrieved key>;
    $text = $in;
    $outText = '';

    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
    $outText .= $text[$i] ^ $key[$i % strlen($key)];
    }

    return $outText;
}

$forged_plaintext = json_encode(array( "showpassword"=>"yes", "bgcolor"=>"#ffffff"));
$forged_cyphertext = xor_encrypt($forged_plaintext);
$forged_data = base64_encode($forger_cyphertext);
echo "$forged_data";
```

Now we simply need to send the result using `curl` like we did in previous levels:

```bash
curl -u natas11:<password> --cookie data=<forged_data> http://natas11.natas.labs.overthewire.org
```

The password should appear on screen.

## ADDITIONAL CONTEXT
### 1
XOR (`^`) compares two bits:

|  A  |  B  |  A XOR B  |
| :--- | :---: | -------: |
|  0  |  0  |  0       |
|  0  |  1  |  1       |
|  1  |  0  |  1       |
|  1  |  1  |  0       |

Note this useful property of XOR:

```
(A ^ B) ^ B = A
```

Because of this property, if the same XOR key is reused across multiple messages, attackers can often recover the key or reconstruct plaintext data by comparing known plaintexts and ciphertexts, making repeated-key XOR especially vulnerable to cryptographic analysis.

### 2
A One-Time Pad (OTP) is an encryption method that uses a completely random key that is at least as long as the message itself. Each character of the plaintext is combined with a corresponding character of the key, often using XOR operations. 

When the key is truly random, used only once, and kept secret, the one-time pad is considered theoretically unbreakable. However, reusing the same key across multiple messages completely breaks this security model and can allow attackers to recover plaintexts or even the key itself.

## SUMMARY
We have retrieved the key from a poorly implemented XOR encryption scheme and used it to forge a cookie and obtain the password.
