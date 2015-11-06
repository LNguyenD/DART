/**
* hoverIntent r5 // 2007.03.27 // jQuery 1.1.2+
* <http://cherne.net/brian/resources/jquery.hoverIntent.html>
* 
* @param  f  onMouseOver function || An object with configuration options
* @param  g  onMouseOut function  || Nothing (use configuration options object)
* @author    Brian Cherne <brian@cherne.net>
*/
(function ($) { $.fn.hoverIntent = function (f, g) { var cfg = { sensitivity: 7, interval: 100, timeout: 0 }; cfg = $.extend(cfg, g ? { over: f, out: g} : f); var cX, cY, pX, pY; var track = function (ev) { cX = ev.pageX; cY = ev.pageY; }; var compare = function (ev, ob) { ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t); if ((Math.abs(pX - cX) + Math.abs(pY - cY)) < cfg.sensitivity) { $(ob).unbind("mousemove", track); ob.hoverIntent_s = 1; return cfg.over.apply(ob, [ev]); } else { pX = cX; pY = cY; ob.hoverIntent_t = setTimeout(function () { compare(ev, ob); }, cfg.interval); } }; var delay = function (ev, ob) { ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t); ob.hoverIntent_s = 0; return cfg.out.apply(ob, [ev]); }; var handleHover = function (e) { var p = (e.type == "mouseover" ? e.fromElement : e.toElement) || e.relatedTarget; while (p && p != this) { try { p = p.parentNode; } catch (e) { p = this; } } if (p == this) { return false; } var ev = jQuery.extend({}, e); var ob = this; if (ob.hoverIntent_t) { ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t); } if (e.type == "mouseover") { pX = ev.pageX; pY = ev.pageY; $(ob).bind("mousemove", track); if (ob.hoverIntent_s != 1) { ob.hoverIntent_t = setTimeout(function () { compare(ev, ob); }, cfg.interval); } } else { $(ob).unbind("mousemove", track); if (ob.hoverIntent_s == 1) { ob.hoverIntent_t = setTimeout(function () { delay(ev, ob); }, cfg.timeout); } } }; return this.mouseover(handleHover).mouseout(handleHover); }; })(jQuery);

(function ($) { $.fn.dcAccordion = function (options) { var defaults = { classParent: 'dcjq-parent', classActive: 'active', classArrow: 'dcjq-icon', classCount: 'dcjq-count', classExpand: 'dcjq-current-parent', eventType: 'click', hoverDelay: 100, menuClose: true, autoClose: true, autoExpand: false, speed: 'slow', saveState: true, disableLink: true, showCount: false, cookie: 'dcjq-accordion' }; var options = $.extend(defaults, options); this.each(function (options) { var obj = this; setUpAccordion(); if (defaults.saveState == true) { checkCookie(defaults.cookie, obj) } if (defaults.autoExpand == true) { $('li.' + defaults.classExpand + ' > a').addClass(defaults.classActive) } resetAccordion(); if (defaults.eventType == 'hover') { var config = { sensitivity: 2, interval: defaults.hoverDelay, over: linkOver, timeout: defaults.hoverDelay, out: linkOut }; $('li a', obj).hoverIntent(config); var configMenu = { sensitivity: 2, interval: 1000, over: menuOver, timeout: 1000, out: menuOut }; $(obj).hoverIntent(configMenu); if (defaults.disableLink == true) { $('li a', obj).click(function (e) { if ($(this).siblings('ul').length > 0) { e.preventDefault() } }) } } else { $('li a', obj).click(function (e) { $activeLi = $(this).parent('li'); $parentsLi = $activeLi.parents('li'); $parentsUl = $activeLi.parents('ul'); if (defaults.disableLink == true) { if ($(this).siblings('ul').length > 0) { e.preventDefault() } } if (defaults.autoClose == true) { autoCloseAccordion($parentsLi, $parentsUl) } if ($('> ul', $activeLi).is(':visible')) { $('ul', $activeLi).slideUp(defaults.speed); $('a', $activeLi).removeClass(defaults.classActive) } else { $(this).siblings('ul').slideToggle(defaults.speed); $('> a', $activeLi).addClass(defaults.classActive) } if (defaults.saveState == true) { createCookie(defaults.cookie, obj) } }) } function setUpAccordion() { $arrow = '<span class="' + defaults.classArrow + '"></span>'; var classParentLi = defaults.classParent + '-li'; $('> ul', obj).show(); $('li', obj).each(function () { if ($('> ul', this).length > 0) { $(this).addClass(classParentLi); $('> a', this).addClass(defaults.classParent).append($arrow) } }); $('> ul', obj).hide(); if (defaults.showCount == true) { $('li.' + classParentLi, obj).each(function () { if (defaults.disableLink == true) { var getCount = parseInt($('ul a:not(.' + defaults.classParent + ')', this).length) } else { var getCount = parseInt($('ul a', this).length) } $('> a', this).append(' <span class="' + defaults.classCount + '">(' + getCount + ')</span>') }) } } function linkOver() { $activeLi = $(this).parent('li'); $parentsLi = $activeLi.parents('li'); $parentsUl = $activeLi.parents('ul'); if (defaults.autoClose == true) { autoCloseAccordion($parentsLi, $parentsUl) } if ($('> ul', $activeLi).is(':visible')) { $('ul', $activeLi).slideUp(defaults.speed); $('a', $activeLi).removeClass(defaults.classActive) } else { $(this).siblings('ul').slideToggle(defaults.speed); $('> a', $activeLi).addClass(defaults.classActive) } if (defaults.saveState == true) { createCookie(defaults.cookie, obj) } } function linkOut() { } function menuOver() { } function menuOut() { if (defaults.menuClose == true) { $('ul', obj).slideUp(defaults.speed); $('a', obj).removeClass(defaults.classActive); createCookie(defaults.cookie, obj) } } function autoCloseAccordion($parentsLi, $parentsUl) { $('ul', obj).not($parentsUl).slideUp(defaults.speed); $('a', obj).removeClass(defaults.classActive); $('> a', $parentsLi).addClass(defaults.classActive) } function resetAccordion() { $('ul', obj).hide(); $allActiveLi = $('a.' + defaults.classActive, obj); $allActiveLi.siblings('ul').show() } }); function checkCookie(cookieId, obj) { var cookieVal = $.cookie(cookieId); if (cookieVal != null) { var activeArray = cookieVal.split(','); $.each(activeArray, function (index, value) { var $cookieLi = $('li:eq(' + value + ')', obj); $('> a', $cookieLi).addClass(defaults.classActive); var $parentsLi = $cookieLi.parents('li'); $('> a', $parentsLi).addClass(defaults.classActive) }) } } function createCookie(cookieId, obj) { var activeIndex = []; $('li a.' + defaults.classActive, obj).each(function (i) { var $arrayItem = $(this).parent('li'); var itemIndex = $('li', obj).index($arrayItem); activeIndex.push(itemIndex) }); $.cookie(cookieId, activeIndex, { path: '/' }) } } })(jQuery);

/**
* Cookie plugin
*
* Copyright (c) 2006 Klaus Hartl (stilbuero.de)
* Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/licenses/gpl.html
*
*/

/**
* Create a cookie with the given name and value and other optional parameters.
*
* @example $.cookie('the_cookie', 'the_value');
* @desc Set the value of a cookie.
* @example $.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });
* @desc Create a cookie with all available options.
* @example $.cookie('the_cookie', 'the_value');
* @desc Create a session cookie.
* @example $.cookie('the_cookie', null);
* @desc Delete a cookie by passing null as value. Keep in mind that you have to use the same path and domain
*       used when the cookie was set.
*
* @param String name The name of the cookie.
* @param String value The value of the cookie.
* @param Object options An object literal containing key/value pairs to provide optional cookie attributes.
* @option Number|Date expires Either an integer specifying the expiration date from now on in days or a Date object.
*                             If a negative value is specified (e.g. a date in the past), the cookie will be deleted.
*                             If set to null or omitted, the cookie will be a session cookie and will not be retained
*                             when the the browser exits.
* @option String path The value of the path atribute of the cookie (default: path of page that created the cookie).
* @option String domain The value of the domain attribute of the cookie (default: domain of page that created the cookie).
* @option Boolean secure If true, the secure attribute of the cookie will be set and the cookie transmission will
*                        require a secure protocol (like HTTPS).
* @type undefined
*
* @name $.cookie
* @cat Plugins/Cookie
* @author Klaus Hartl/klaus.hartl@stilbuero.de
*/

/**
* Get the value of a cookie with the given name.
*
* @example $.cookie('the_cookie');
* @desc Get the value of a cookie.
*
* @param String name The name of the cookie.
* @return The value of the cookie.
* @type String
*
* @name $.cookie
* @cat Plugins/Cookie
* @author Klaus Hartl/klaus.hartl@stilbuero.de
*/
jQuery.cookie = function (name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        // CAUTION: Needed to parenthesize options.path and options.domain
        // in the following expressions, otherwise they evaluate to undefined
        // in the packed version for some reason...
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

$(document).ready(function () {
    // Menu
    $('#mainNav').dcAccordion({
        eventType: 'hover',
        autoClose: true,
        saveState: true,
        disableLink: true,
        menuClose: true,
        speed: 'fast',
        showCount: false
    }); 
});