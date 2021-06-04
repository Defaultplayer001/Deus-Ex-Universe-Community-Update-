function toggle( targetId ){
  if (document.getElementById){
               target = document.getElementById( targetId );
                       if (target.style.display == "none"){
                               target.style.display = "";
                       } else {
                               target.style.display = "none";
                       }
       }
}

function perPageChanges(web, topic) {
  if (topic == "WebIndex" || topic.substring(0,10) == "WebChanges") {
     document.getElementById("tool").style.display = "none";
  }
  if (topic == "WebHome" || topic == "WebHomeBeta") {
     document.getElementById("topicslink").style.display = "none";
     document.getElementById("relatedcats").style.display = "none";
     document.getElementById("topicversion").style.display = "none";
     //document.getElementById("toolband").style.display = "none";
     //document.getElementById("tooltexttwo").style.display = "none";
  }
}
