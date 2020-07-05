
obj:=ComObjCreate("HTMLfile")

;---load javascript---

;build-in script
buildInScript=
( LTrim
<script>
var funcArr=['abs','acos','asin','atan','atan2','ceil','cos','exp','floor','log','max','min','pow','random','round','sin','sqrt','tan'];
var consArr=['E','LN2','LN10','LOG2E','LOG10E','PI','SQRT1_2','SQRT2'];
for(var i=0,len=funcArr.length;i<len;i++){
    window[funcArr[i]]=Math[funcArr[i]];
}
for(var i=0,len=consArr.length;i<len;i++){
    window[consArr[i]]=Math[consArr[i]];
    window[consArr[i].toLowerCase()]=Math[consArr[i]];
}
//fix floating point calculation bug in js like 0.1+0.2=0.30000000000000004
//for(var i=0,k=0;k<100001;k++,i+=0.000001){console.log(i,fixFloatCalcRudely(i));}
function fixFloatCalcRudely(num){
    if(typeof num == 'number'){
        var str=num.toString(),
            match=str.match(/\.(\d*?)(9|0)\2{5,}(\d{1,5})$/);
        if(match != null){
            return num.toFixed(match[1].length)-0;
        }
    }
    return num;
}
function detectAndFixTrivialPow( expressionString ) {

    var pattern = /(\w+)\s*\*\*\s*(\w+)/i;

    var fixed = expressionString.replace( pattern, 'Math.pow($1,$2)' );
    return fixed;
}
</script>
)
obj.write(buildInScript)
buildInScript:=""

jsEval(exp,fix:=true)
{
    global obj
    exp:=escapeString(exp)
    

    ; 四则运算正则匹配
    numCheck = true
    strRegEx:="i)\(*-?\d*\.?\d+\)*(\s?([-+*/]|\*\*)\s?\(*-?\d*\.?\d+\)*)*\s*(\$(b|h|x|)(\d*[eEgG]?))?\s?=?\s?$"
    foundPos:=RegExMatch(exp, strRegEx, calStr)
    if(foundPos){
        numCheck := false
        inputStr:=SubStr(exp,1,foundPos-1)
        ; 说明四则运算正则不匹配，判断是否需要包裹字符串
        if (inputStr != ""){
            numCheck := true
        }
    }

    if (numCheck) {
        RegExMatch(exp, "[a-zA-Z0-9_\{\}\!\+\^\#]*$", match)
        if (exp = match){
            exp := "\""" . exp . "\"""
        }
    }
    ; MsgBox % "exp " exp

    fixfun := fix ? "fixFloatCalcRudely" : ""
    obj.write("<body><script>(function(){var t=document.body;t.innerText='';t.innerText=" . fixfun . "(eval('" . exp . "'));})()</script></body>")
    return inStr(cabbage:=obj.body.innerText, "body") ? "ERROR" : cabbage
}

escapeString(string){
    ;escape http://www.w3school.com.cn/js/js_special_characters.asp
    string:=regExReplace(string, "('|""|&|\\|\\n|\\r|\\t|\\b|\\f)", "\$1")
    
    ;replace all newline character to '\n'
    string:=regExReplace(string, "\R", "\n")
    
    return string
}

