// $(document).ready(function () {
//     $("#template_text").keyup(function () {
//         var text = $("#text").html();
//         var template_text =  $("#template_text").val();
//         $.ajax({
//             url: "/type_races/create",
//             type: "POST",
//             dataType: 'json',
//             data :{"text_area": template_text },
//             success: function (data,status,jqXHR) {
//                 $("#dummy_text").val(template_text);
//             },
//             error: function () {
//
//             }
//         });
//     });
// });




var countCharacters=0;
var startTime;
var userKeyPressCount=0;

$(document).on("turbolinks:load", function () {
    arrayOfText();

    $("button").on("click",function () {

        $('#template_text').focus();
        $('#template_text').val("");
    });
        $("#template_text").keyup(function () {
        var text = $("#text").html();
        var template_text =  $("#template_text").val();
        $.ajax({
            url: "/type_races/create",
            type: "POST",
            dataType: 'json',
            data :{"text_area": template_text },
            success: function (data,status,jqXHR) {
            },
            error: function () {

            }
        });
    });
    $("#template_text").on("input",function(event){
        if (startTime === undefined) {
            startTime = new Date($.now());
        }

        var modifierKeyKeyCodes = [16,17,18,20,27,37,38,39,40,46];
        if (modifierKeyKeyCodes.includes(event.keyCode) == false) {
            userKeyPressCount++;
        }

        updateWPM();
        updateProgressBar();
        giveColorFeedback();
        if (isGameOver() == true){
            handleGameOver();
        }
    });
});

function arrayOfText() {
debugger
    var textTemplate=$("#text").html();
    var textTemplateCharArray = textTemplate.split("");
    for(var spanCount=0; spanCount < textTemplateCharArray.length; spanCount++) {
        textTemplateCharArray[spanCount] = '<span id= "'+spanCount +'">' + textTemplateCharArray[spanCount] + '</span>';
    }
    var textTemplateSpanified = textTemplateCharArray.join("");
    $("#text").html(textTemplateSpanified);
}

function updateWPM(){
    countCharacters += 1;
    var currentTime=new Date($.now());
    var timeInSecs = (currentTime-startTime)/1000;
    var timeInMins = timeInSecs/60;
    var wordsWritten = countCharacters/5;
    var wpm = wordsWritten/timeInMins;
    wpm = parseInt(wpm,10);
    $('#checkWpm').text(wpm);
}
function updateProgressBar(){
    var percentage = 3 + getProgress();
    var progressBarSelector = $("#newBar");
    var progressBar = $(progressBarSelector);
    var text = $('#text').text();
    var template_text = $('#template_text').val();
    var currentCharIndex = template_text.length - 1;
    for(var i = currentCharIndex; i <= text.length - 1 ; i++) {
        if (template_text[currentCharIndex] === text[currentCharIndex]) {
            $(progressBar).css("width", percentage + "%" );
            // $("#newBar").animate({left: "+=500"}, 2000);
        }
    }
}
function getProgress(){

    var template_textLength = $("#template_text").val().length;
    var quoteLength = $("#text").text().length;
    return ((template_textLength / quoteLength) * 100);
}

function giveColorFeedback(){
    var text = $('#text').text();
    var template_text = $('#template_text').val();
    var currentCharIndex = template_text.length - 1;

    for(var i = currentCharIndex; i < text.length - 1 ; i++){
        $("span #" + i).removeClass("match").removeClass("unmatch");
    }

    if (template_text[currentCharIndex] === text[currentCharIndex]){
        $("span #" + currentCharIndex).addClass("match").removeClass("unmatch");
    } else {
        $("span #" + currentCharIndex).removeClass("match").addClass("unmatch");
    }
}

function isGameOver(){
    return ($('#text').text()===$('#template_text').val())
}

function handleGameOver() {
    displayAccuracy();
    disableInput();
}

function displayAccuracy() {
    var textCharLen= $('#text').text().length;
    var userKeyPressInputCharLen=userKeyPressCount;
    var accuracy = ( textCharLen/userKeyPressInputCharLen )*100;
    accuracy=Math.round( accuracy );
    $('#showAccuracy').removeClass("hidden");
    $(' #accuracy').text(accuracy);
}
function disableInput() {
    $('#template_text').prop('disabled', true);
}





var quotes = ["Hello there", "Genius is one percent inspiration and ninety-nine percent perspiration.", "You can observe a lot just by watching.","A house divided against itself cannot stand.",
    "Difficulties increase the nearer we get to the goal.","Fate is in your hands and no one elses",
    "Be the chief but never the lord.","Nothing happens unless first we dream.","Well begun is half done.", "Life is a learning experience, only if you learn."
    ,"Self-complacency is fatal to progress.","Peace comes from within. Do not seek it without.","What you give is what you get.",
    "We can only learn to love by loving.","Life is change. Growth is optional. Choose wisely.","You'll see it when you believe it."
    ,"Today is the tomorrow we worried about yesterday.","It's easier to see the mistakes on someone else's paper."
    , "Every man dies. Not every man really lives.","To lead people walk behind them.","Having nothing, nothing can he lose."]
