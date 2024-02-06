// ============================================================================
// dhtml-menu.js
//
// Copyright 2002 by Michael "Mych" Buschbeck <mychaeel@beyondunreal.com>
// Originally created for the Unreal Wiki, http://wiki.beyondunreal.com
//
// Feel free to use and modify. Do not distribute modified versions with the
// above copyright notice. If you use this script as-is or with just minor
// changes, be nice and give me some credit.
// ============================================================================


var menuVisible = false;
var menuText = "";

var menuAlignRight  = true;
var menuAlignBottom = true;

var menuColorHoverFore  = "#eee";
var menuColorHoverBack  = "#000";
var menuColorNormalFore = "#000";
var menuColorNormalBack = "#eee";

var menuItemId = 0;
var menuItemUrl = new Array();


function menuInit() {

  if (DOM && !MS && !OP)
    getElem("tagname", "body", 0).addEventListener("mousemove", handleMove, true);

  if (NS) {
    document.captureEvents(Event.MOUSEMOVE);
    document.onmousemove = handleMove;
    }

  if (DOM && OP)
    document.onmousemove = handleMove;

  if (MS)
    getElem("tagname", "body", 0).onmousemove = handleMoveMS;
  }


function menuItemAdd(caption, url) {

  DHTML_init();

  if (NS) {
    menuText = menuText + '<a href="javascript:menuItemSelect(' + menuItemId + ')">';
    menuText = menuText + '<tt>&nbsp;&nbsp;</tt>';
    menuText = menuText + caption;
    menuText = menuText + '<tt>&nbsp;&nbsp;</tt>';
    menuText = menuText + '</a>';
    menuText = menuText + '<br>';
    menuText = menuText + '\n';
    }

  else {
    menuText = menuText + '<tr>';
    menuText = menuText + '<td onMouseOver="menuItemOver(this)"';
    menuText = menuText +    ' onMouseOut="menuItemOut(this)"';
    menuText = menuText +    ' onMouseUp="menuItemSelect(' + menuItemId + ')">';
    menuText = menuText + caption;
    menuText = menuText + '</td>';
    menuText = menuText + '</tr>';
    }

  menuItemUrl[menuItemId] = url;
  menuItemId++;
  }


function menuItemSeparator() {

  menuText = menuText + '<tr><td id="dhtml-menu-separator"></td></tr>';
  }


function menuItemOver(element) {

  element.style.color = menuColorHoverFore;
  element.style.backgroundColor = menuColorHoverBack;
  }


function menuItemOut(element) {
  
  element.style.color = menuColorNormalFore;

  if (OP)
    element.style.backgroundColor = menuColorNormalBack;
  else
    element.style.backgroundColor = "transparent";
  }


function menuItemSelect(id) {

  menuHide();

  location.href = menuItemUrl[id];
  }


function menuWrite() {

  DHTML_init();

  if (NS) {
    document.write('<layer position=absolute visibility=hidden id="dhtml-menu">');
    document.write(menuText);
    document.write('</layer>');
    }

  else {
    document.write('<div style="position: absolute; left: 10px; top: 10px; visibility: hidden;" id="dhtml-menu">');
    document.write('<table border=0 cellspacing=0 cellpadding=0>');
    document.write(menuText);
    document.write('</table>');
    document.write('</div>');
    }
  }


function menuWriteAnchor(text) {

  DHTML_init();

  if (NS) {
    document.write('<ilayer position=relative id="dhtml-menu-anchor">');
    document.write(text);
    document.write('</ilayer>');
    }
    
  else {
    document.write('<span style="position: relative" id="dhtml-menu-anchor">');
    document.write(text);
    document.write('</span>');
    }
  }


function menuShow() {

  if (menuVisible)
    return;

  var menuAnchor = getElem("id", "dhtml-menu-anchor", null);
  var menuLayer  = getElem("id", "dhtml-menu", null);

  if (!menuLayer)
    return;

  var menuPositionLeft = getElementLeft(menuAnchor);
  var menuPositionTop  = getElementTop (menuAnchor);

  if (menuAlignRight)
    menuPositionLeft -= getElementWidth(menuLayer) - getElementWidth(menuAnchor);

  if (menuAlignBottom)
    menuPositionTop += getElementHeight(menuAnchor);
  else
    menuPositionTop -= getElementHeight(menuLayer);

  if (NS) {
    menuLayer.left = menuPositionLeft;
    menuLayer.top  = menuPositionTop;
    menuLayer.visibility = "show";
    }
  
  else {
    menuLayer.style.left = menuPositionLeft + "px";
    menuLayer.style.top  = menuPositionTop  + "px";
    menuLayer.style.visibility = "visible";
    }

  menuVisible = true;
  }


function menuHide() {

  if (!menuVisible)
    return;

  var menuLayer  = getElem("id", "dhtml-menu", null);

  if (!menuLayer)
    return;

  if (NS)
    menuLayer.visibility = "hide";
  else
    menuLayer.style.visibility = "hidden";

  menuVisible = false;
  }


function handleMove(eventMove) {

  if (MS)
    return;

  if (OP)
    menuCheck(eventMove.clientX, eventMove.clientY);
  else
    menuCheck(eventMove.pageX, eventMove.pageY);
  }


function handleMoveMS() {

  if (!MS)
    return;

  menuCheck(window.event.clientX + getScrollLeft(),
            window.event.clientY + getScrollTop());
  }


function menuCheck(mouseX, mouseY) {

  if (mouseTouches(getElem("id", "dhtml-menu-anchor", null), mouseX, mouseY) ||
     (mouseTouches(getElem("id", "dhtml-menu", null), mouseX, mouseY) && menuVisible))
    menuShow();
  else
    menuHide();
  }


function mouseTouches(element, mouseX, mouseY) {

  if (!element)
    return false;

  return (mouseX >= getElementLeft(element) && mouseX < getElementLeft(element) + getElementWidth (element) &&
          mouseY >= getElementTop (element) && mouseY < getElementTop (element) + getElementHeight(element));
  }


function getElementLeft(element) {

  if (NS)
    return element.pageX;
  
  var elementLeft = element.offsetLeft;

  while (element.offsetParent) {
    element = element.offsetParent;
    elementLeft += element.offsetLeft;
    }

  return elementLeft;
  }


function getElementTop(element) {

  if (NS)
    return element.pageY;

  var elementTop = element.offsetTop;

  while (element.offsetParent) {
    element = element.offsetParent;
    elementTop += element.offsetTop;
    }

  return elementTop;
  }


function getElementWidth(element) {

  if (NS)
    return element.clip.width;
  
  return element.offsetWidth;
  }


function getElementHeight(element) {

  if (NS)
    return element.clip.height;
  
  return element.offsetHeight;
  }


function getScrollLeft() {

  if (MS)
    return document.body.scrollLeft;

  return window.pageXOffset;
  }


function getScrollTop() {

  if (MS)
    return document.body.scrollTop;

  return window.pageYOffset;
  }
