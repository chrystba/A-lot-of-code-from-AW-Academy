var version=sap.ui.version.split(".");if(parseInt(version[0],10)<=1&&parseInt(version[1],10)<78){sap.ui.getCore().loadLibraries(["sap/ui/fl"]);sap.ui.require(["sap/ui/fl/FakeLrepConnector"],function(e){jQuery.extend(e.prototype,{create:function(e){return+
 Promise.resolve()},stringToAscii:function(e){if(!e||e.length===0){return""}var n="";for(var t=0;t<e.length;t++){n+=e.charCodeAt(t)+","}if(n!==null&&n.length>0&&n.charAt(n.length-1)===","){n=n.substring(0,n.length-1)}return n},loadChanges:function(){var +
n={changes:[],settings:{isKeyUser:true,isAtoAvailable:false,isProductiveSystem:false}};var t=[];var a="/sap-ui-cachebuster-info.json";var o=[/^localhost$/,/^.*.applicationstudio.cloud.sap$/];var r=new URL(window.location.toString());var i=o.some(e=>e.tes+
t(r.hostname));return new Promise(function(o,c){if(!i){c("cannot load flex changes: invalid host")}$.ajax({url:r.origin+a,type:"GET",cache:false}).then(function(e){var n=Object.keys(e).filter(function(e){return e.endsWith(".change")});$.each(n,function(e+
,n){if(n.indexOf("changes")===0){if(!i){c("cannot load flex changes: invalid host")}t.push($.ajax({url:r.origin+"/"+n,type:"GET",cache:false}).then(function(e){return JSON.parse(e)}))}})}).always(function(){return Promise.all(t).then(function(a){return n+
ew Promise(function(e,n){if(a.length===0){if(!i){n("cannot load flex changes: invalid host")}$.ajax({url:r.origin+"/changes/",type:"GET",cache:false}).then(function(a){var o=/(\/changes\/[^"]*\.[a-zA-Z]*)/g;var c=o.exec(a);while(c!==null){if(!i){n("canno+
t load flex changes: invalid host")}t.push($.ajax({url:r.origin+c[1],type:"GET",cache:false}).then(function(e){return JSON.parse(e)}));c=o.exec(a)}e(Promise.all(t))}).fail(function(n){e(a)})}else{e(a)}}).then(function(t){var a=[],r=[];t.forEach(function(+
n){var t=n.changeType;if(t==="addXML"||t==="codeExt"){var o=t==="addXML"?n.content.fragmentPath:t==="codeExt"?n.content.codeRef:"";var i=o.match(/webapp(.*)/);var c="/"+i[0];a.push($.ajax({url:c,type:"GET",cache:false}).then(function(a){if(t==="addXML"){+
n.content.fragment=e.prototype.stringToAscii(a.documentElement.outerHTML);n.content.selectedFragmentContent=a.documentElement.outerHTML}else if(t==="codeExt"){n.content.code=e.prototype.stringToAscii(a);n.content.extensionControllerContent=a}return n}))}+
else{r.push(n)}});if(a.length>0){return Promise.all(a).then(function(e){e.forEach(function(e){r.push(e)});r.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=r;var t={changes:n,componentClassName:"zdevcgrp2"};o(t)})}else{r.s+
ort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=r;var i={changes:n,componentClassName:"zdevcgrp2"};o(i)}})})})})}});e.enableFakeConnector()})}                                                                                  