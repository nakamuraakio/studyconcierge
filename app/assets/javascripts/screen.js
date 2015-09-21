/*
screen.js
*/

function adjustLayout() {
    if(window.innerWidth < 520){
        var mentorTable = document.getElementsByName('mentor_table');
        for(var i = 0; i < mentorTable.length; i++){
            mentorTable[i].style.width = "100%";
            mentorTable[i].style.marginLeft = "0px";
        }
    }
}

window.addEventListener('load', adjustLayout, false);