//
//  _Wrapper+UtilityTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+UtilityTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation _Wrapper_UtilityTests

- (void)test_identity 
{
  O* moe = OKV({@"name", @"moe"});
  self.equal(_.identity(moe), moe, @"moe is the same as his identity");
}

- (void)test_uniqueId 
{
  A* ids = A.new; I i = 0;
  while(i++ < 100) ids.push(_.uniqueId(/* NIL_TERMINATION */ nil));
  self.equalI(_.uniq(ids).length, ids.length, @"can generate a globally-unique stream of ids");
}

- (void)test_times 
{
  A* vals = A.new;
  _.chain(N.I(3)).times(^(I i) { vals.push(N.I(i)); });
  self.ok(_.isEqual(vals, AI(0,1,2)), @"is 0 indexed");
  //
  vals = A.new;
  _.chain(N.I(3)).times(^(I i) { vals.push(N.I(i)); });
  self.ok(_.isEqual(vals, AI(0,1,2)), @"works as a wrapper");
}

/* NOT SUPPORTED: JavaScript-only */
//- (void)test_mixin 
//{
//  _.mixin({
//    myReverse: function(string) {
//      return string.split(@"").reverse().join(@"");
//    }
//  });
//  self.equal(_.myReverse(@"panacea"), @"aecanap", @"mixed in a function to _");
//  self.equal(_(@"champ").myReverse(), @"pmahc", @"mixed in a function to the OOP wrapper");
//}

/* NOT SUPPORTED: JavaScript-only */
//- (void)test_escape 
//{
//  self.equal(_.escape(@"Curly & Moe"), @"Curly &amp; Moe", @"escaped");
//  self.equal(_.escape(@"Curly &amp; Moe"), @"Curly &amp;amp; Moe", @"escaped escaped");
//}

/* NOT SUPPORTED: JavaScript-only */
//- (void)test_template 
//{
//  var basicTemplate = _.template("<%= thing %> is gettin" on my noives!");
//  var result = basicTemplate({thing : "This"});
//  self.equal(result, "This is gettin" on my noives!", "can do basic attribute interpolation");
//
//  var sansSemicolonTemplate = _.template("A <% this %> B");
//  self.equal(sansSemicolonTemplate(), "A  B");
//
//  var backslashTemplate = _.template("<%= thing %> is \\ridanculous");
//  self.equal(backslashTemplate({thing: "This"}), "This is \\ridanculous");
//
//  var escapeTemplate = _.template("<%= a ? "checked=\\"checked\\"" : "" %>");
//  self.equal(escapeTemplate({a: true}), "checked="checked"", "can handle slash escapes in interpolations.");
//
//  var fancyTemplate = _.template("<ul><% \
//    for (key in people) { \
//  %><li><%= people[key] %></li><% } %></ul>");
//  result = fancyTemplate({people : {moe : "Moe", larry : "Larry", curly : "Curly"}});
//  self.equal(result, "<ul><li>Moe</li><li>Larry</li><li>Curly</li></ul>", "can run arbitrary javascript in templates");
//
//  var escapedCharsInJavascriptTemplate = _.template("<ul><% _.each(numbers.split("\\n"), function(item) { %><li><%= item %></li><% }) %></ul>");
//  result = escapedCharsInJavascriptTemplate({numbers: "one\ntwo\nthree\nfour"});
//  self.equal(result, "<ul><li>one</li><li>two</li><li>three</li><li>four</li></ul>", "Can use escaped characters (e.g. \\n) in Javascript");
//
//  var namespaceCollisionTemplate = _.template("<%= pageCount %> <%= thumbnails[pageCount] %> <% _.each(thumbnails, function(p) { %><div class=\"thumbnail\" rel=\"<%= p %>\"></div><% }); %>");
//  result = namespaceCollisionTemplate({
//    pageCount: 3,
//    thumbnails: {
//      1: "p1-thumbnail.gif",
//      2: "p2-thumbnail.gif",
//      3: "p3-thumbnail.gif"
//    }
//  });
//  self.equal(result, "3 p3-thumbnail.gif <div class=\"thumbnail\" rel=\"p1-thumbnail.gif\"></div><div class=\"thumbnail\" rel=\"p2-thumbnail.gif\"></div><div class=\"thumbnail\" rel=\"p3-thumbnail.gif\"></div>");
//
//  var noInterpolateTemplate = _.template("<div><p>Just some text. Hey, I know this is silly but it aids consistency.</p></div>");
//  result = noInterpolateTemplate();
//  self.equal(result, "<div><p>Just some text. Hey, I know this is silly but it aids consistency.</p></div>");
//
//  var quoteTemplate = _.template("It"s its, not it"s");
//  self.equal(quoteTemplate({}), "It"s its, not it"s");
//
//  var quoteInStatementAndBody = _.template("<%\
//    if(foo == "bar"){ \
//  %>Statement quotes and "quotes".<% } %>");
//  self.equal(quoteInStatementAndBody({foo: "bar"}), "Statement quotes and "quotes".");
//
//  var withNewlinesAndTabs = _.template("This\n\t\tis: <%= x %>.\n\tok.\nend.");
//  self.equal(withNewlinesAndTabs({x: "that"}), "This\n\t\tis: that.\n\tok.\nend.");
//
//  var template = _.template("<i><%- value %></i>");
//  var result = template({value: "<script>"});
//  self.equal(result, "<i>&lt;script&gt;</i>");
//
//  var stooge = {
//    name: "Moe",
//    template: _.template("I"m <%= this.name %>")
//  };
//  self.equal(stooge.template(), "I"m Moe");
//
//  if (!$.browser.msie) {
//    var fromHTML = _.template($("#template").html());
//    self.equal(fromHTML({data : 12345}).replace(/\s/g, ""), "<li>24690</li>");
//  }
//
//  _.templateSettings = {
//    evaluate    : /\{\{([\s\S]+?)\}\}/g,
//    interpolate : /\{\{=([\s\S]+?)\}\}/g
//  };
//
//  var custom = _.template("<ul>{{ for (key in people) { }}<li>{{= people[key] }}</li>{{ } }}</ul>");
//  result = custom({people : {moe : "Moe", larry : "Larry", curly : "Curly"}});
//  self.equal(result, "<ul><li>Moe</li><li>Larry</li><li>Curly</li></ul>", "can run arbitrary javascript in templates");
//
//  var customQuote = _.template("It"s its, not it"s");
//  self.equal(customQuote({}), "It"s its, not it"s");
//
//  var quoteInStatementAndBody = _.template("{{ if(foo == "bar"){ }}Statement quotes and "quotes".{{ } }}");
//  self.equal(quoteInStatementAndBody({foo: "bar"}), "Statement quotes and "quotes".");
//
//  _.templateSettings = {
//    evaluate    : /<\?([\s\S]+?)\?>/g,
//    interpolate : /<\?=([\s\S]+?)\?>/g
//  };
//
//  var customWithSpecialChars = _.template("<ul><? for (key in people) { ?><li><?= people[key] ?></li><? } ?></ul>");
//  result = customWithSpecialChars({people : {moe : "Moe", larry : "Larry", curly : "Curly"}});
//  self.equal(result, "<ul><li>Moe</li><li>Larry</li><li>Curly</li></ul>", "can run arbitrary javascript in templates");
//
//  var customWithSpecialCharsQuote = _.template("It"s its, not it"s");
//  self.equal(customWithSpecialCharsQuote({}), "It"s its, not it"s");
//
//  var quoteInStatementAndBody = _.template("<? if(foo == "bar"){ ?>Statement quotes and "quotes".<? } ?>");
//  self.equal(quoteInStatementAndBody({foo: "bar"}), "Statement quotes and "quotes".");
//
//  _.templateSettings = {
//    interpolate : /\{\{(.+?)\}\}/g
//  };
//
//  var mustache = _.template("Hello {{planet}}!");
//  self.equal(mustache({planet : "World"}), "Hello World!", "can mimic mustache.js");
//
//  var templateWithNull = _.template("a null undefined {{planet}}");
//  self.equal(templateWithNull({planet : "world"}), "a null undefined world", "can handle missing escape and evaluate settings");
//}
//
//- (void)test_template_handles_escaped_characters // \\u2028 & \\u2029
//{
//  var tmpl = _.template("<p>\u2028<%= "\\u2028\\u2029" %>\u2029</p>");
//  strictEqual(tmpl(), "<p>\u2028\u2028\u2029\u2029</p>");
//}
//
//- (void)test_result_calls_functions_and_returns_primitives
//{
//  var obj = {w: "", x: "x", y: function(){ return this.x; }};
//  strictEqual(_.result(obj, "w"), "");
//  strictEqual(_.result(obj, "x"), "x");
//  strictEqual(_.result(obj, "y"), "x");
//  strictEqual(_.result(obj, "z"), undefined);
//  strictEqual(_.result(null, "x"), null);
//}
//
//- (void)test_templateSettings_variable
//{
//  var s = "<%=data.x%>";
//  var data = {x: "x"};
//  strictEqual(_.template(s, data, {variable: "data"}), "x");
//  _.templateSettings.variable = "data";
//  strictEqual(_.template(s)(data), "x");
//}
//
//test("#547 - _.templateSettings is unchanged by custom settings.", function() {
//  self.ok(!_.templateSettings.variable);
//  _.template("", {}, {variable: "x"});
//  self.ok(!_.templateSettings.variable);
//}
//
//test("#556 - undefined template variables.", function() {
//  var template = _.template("<%=x%>");
//  strictEqual(template({x: null}), "");
//  strictEqual(template({x: undefined}), "");
//
//  var templateEscaped = _.template("<%-x%>");
//  strictEqual(templateEscaped({x: null}), "");
//  strictEqual(templateEscaped({x: undefined}), "");
//
//  var templateWithProperty = _.template("<%=x.foo%>");
//  strictEqual(templateWithProperty({x: {} }), "");
//  strictEqual(templateWithProperty({x: {} }), "");
//
//  var templateWithPropertyEscaped = _.template("<%-x.foo%>");
//  strictEqual(templateWithPropertyEscaped({x: {} }), "");
//  strictEqual(templateWithPropertyEscaped({x: {} }), "");
//}
//
//test("interpolate evaluates code only once.", 2, function() {
//  var count = 0;
//  var template = _.template("<%= f() %>");
//  template({f: function(){ self.ok(!(count++)); }});
//
//  var countEscaped = 0;
//  var templateEscaped = _.template("<%- f() %>");
//  templateEscaped({f: function(){ self.ok(!(countEscaped++)); }});
//}

@end
