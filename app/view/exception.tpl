<?php
/** @var array $traces */
if (!function_exists('parse_padding')) {
    function parse_padding($source)
    {
        $length  = strlen(strval(count($source['source']) + $source['first']));
        return 40 + ($length - 1) * 8;
    }
}

if (!function_exists('parse_class')) {
    function parse_class($name)
    {
        $names = explode('\\', $name);
        return '<abbr title="'.$name.'">'.end($names).'</abbr>';
}
}

if (!function_exists('parse_file')) {
function parse_file($file, $line)
{
return '<a class="toggle" title="'."{$file} line {$line}".'">'.basename($file)." line {$line}".'</a>';
}
}

if (!function_exists('parse_args')) {
function parse_args($args)
{
$result = [];
foreach ($args as $key => $item) {
switch (true) {
case is_object($item):
$value = sprintf('<em>object</em>(%s)', parse_class(get_class($item)));
break;
case is_array($item):
if (count($item) > 3) {
$value = sprintf('[%s, ...]', parse_args(array_slice($item, 0, 3)));
} else {
$value = sprintf('[%s]', parse_args($item));
}
break;
case is_string($item):
if (strlen($item) > 20) {
$value = sprintf(
'\'<a class="toggle" title="%s">%s...</a>\'',
htmlentities($item),
htmlentities(substr($item, 0, 20))
);
} else {
$value = sprintf("'%s'", htmlentities($item));
}
break;
case is_int($item):
case is_float($item):
$value = $item;
break;
case is_null($item):
$value = '<em>null</em>';
break;
case is_bool($item):
$value = '<em>' . ($item ? 'true' : 'false') . '</em>';
break;
case is_resource($item):
$value = '<em>resource</em>';
break;
default:
$value = htmlentities(str_replace("\n", '', var_export(strval($item), true)));
break;
}

$result[] = is_int($key) ? $value : "'{$key}' => {$value}";
}

return implode(', ', $result);
}
}
if (!function_exists('echo_value')) {
function echo_value($val)
{
if (is_array($val) || is_object($val)) {
echo htmlentities(json_encode($val, JSON_PRETTY_PRINT));
} elseif (is_bool($val)) {
echo $val ? 'true' : 'false';
} elseif (is_scalar($val)) {
echo htmlentities($val);
} else {
echo 'Resource';
}
}
}
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统发生错误</title>
    <meta name="robots" content="noindex,nofollow"/>
    <style>
        /* Base */
        body {
            color: #333;
            font: 16px Verdana, "Helvetica Neue", helvetica, Arial, 'Microsoft YaHei', sans-serif;
            margin: 0;
            padding: 0 20px 20px;
        }

        h1 {
            margin: 10px 0 0;
            font-size: 28px;
            font-weight: 500;
            line-height: 32px;
        }

        h2 {
            color: #4288ce;
            font-weight: 400;
            padding: 6px 0;
            margin: 6px 0 0;
            font-size: 18px;
            border-bottom: 1px solid #eee;
        }

        h3 {
            margin: 12px;
            font-size: 16px;
            font-weight: bold;
        }

        abbr {
            cursor: help;
            text-decoration: underline;
            text-decoration-style: dotted;
        }

        a {
            color: #868686;
            cursor: pointer;
        }

        a:hover {
            text-decoration: underline;
        }

        .line-error {
            background: #f8cbcb;
        }

        .echo table {
            width: 100%;
        }

        .echo pre {
            padding: 16px;
            overflow: auto;
            font-size: 85%;
            line-height: 1.45;
            background-color: #f7f7f7;
            border: 0;
            border-radius: 3px;
            font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace;
        }

        .echo pre > pre {
            padding: 0;
            margin: 0;
        }

        /* Exception Info */
        .exception {
            margin-top: 20px;
        }

        .exception .message {
            padding: 12px;
            border: 1px solid #ddd;
            border-bottom: 0 none;
            line-height: 18px;
            font-size: 16px;
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
            font-family: Consolas, "Liberation Mono", Courier, Verdana, "微软雅黑", serif;
        }

        .exception .code {
            float: left;
            text-align: center;
            color: #fff;
            margin-right: 12px;
            padding: 16px;
            border-radius: 4px;
            background: #999;
        }

        .exception .source-code {
            padding: 6px;
            border: 1px solid #ddd;

            background: #f9f9f9;
            overflow-x: auto;

        }

        .exception .source-code pre {
            margin: 0;
        }

        .exception .source-code pre ol {
            margin: 0;
            color: #4288ce;
            display: inline-block;
            min-width: 100%;
            box-sizing: border-box;
            font-size: 14px;
            font-family: "Century Gothic", Consolas, "Liberation Mono", Courier, Verdana, serif;
            padding-left: < ? php echo (isset($ source) & & ! empty($ source)) ? parse_padding($ source): 40;
            ? > px;
        }

        .exception .source-code pre li {
            border-left: 1px solid #ddd;
            height: 18px;
            line-height: 18px;
        }

        .exception .source-code pre code {
            color: #333;
            height: 100%;
            display: inline-block;
            border-left: 1px solid #fff;
            font-size: 14px;
            font-family: Consolas, "Liberation Mono", Courier, Verdana, "微软雅黑", serif;
        }

        .exception .trace {
            padding: 6px;
            border: 1px solid #ddd;
            border-top: 0 none;
            line-height: 16px;
            font-size: 14px;
            font-family: Consolas, "Liberation Mono", Courier, Verdana, "微软雅黑", serif;
        }

        .exception .trace h2:hover {
            text-decoration: underline;
            cursor: pointer;
        }

        .exception .trace ol {
            margin: 12px;
        }

        .exception .trace ol li {
            padding: 2px 4px;
        }

        .exception div:last-child {
            border-bottom-left-radius: 4px;
            border-bottom-right-radius: 4px;
        }

        /* Exception Variables */
        .exception-var table {
            width: 100%;
            margin: 12px 0;
            box-sizing: border-box;
            table-layout: fixed;
            word-wrap: break-word;
        }

        .exception-var table caption {
            text-align: left;
            font-size: 16px;
            font-weight: bold;
            padding: 6px 0;
        }

        .exception-var table caption small {
            font-weight: 300;
            display: inline-block;
            margin-left: 10px;
            color: #ccc;
        }

        .exception-var table tbody {
            font-size: 13px;
            font-family: Consolas, "Liberation Mono", Courier, "微软雅黑", serif;
        }

        .exception-var table td {
            padding: 0 6px;
            vertical-align: top;
            word-break: break-all;
        }

        .exception-var table td:first-child {
            width: 28%;
            font-weight: bold;
            white-space: nowrap;
        }

        .exception-var table td pre {
            margin: 0;
        }

        /* Copyright Info */
        .copyright {
            margin-top: 24px;
            padding: 12px 0;
            border-top: 1px solid #eee;
        }

        /* SPAN elements with the classes below are added by prettyprint. */
        pre.prettyprint .pln {
            color: #000
        }

        /* plain text */
        pre.prettyprint .str {
            color: #080
        }

        /* string content */
        pre.prettyprint .kwd {
            color: #008
        }

        /* a keyword */
        pre.prettyprint .com {
            color: #800
        }

        /* a comment */
        pre.prettyprint .typ {
            color: #606
        }

        /* a type name */
        pre.prettyprint .lit {
            color: #066
        }

        /* a literal value */
        /* punctuation, lisp open bracket, lisp close bracket */
        pre.prettyprint .pun, pre.prettyprint .opn, pre.prettyprint .clo {
            color: #660
        }

        pre.prettyprint .tag {
            color: #008
        }

        /* a markup tag name */
        pre.prettyprint .atn {
            color: #606
        }

        /* a markup attribute name */
        pre.prettyprint .atv {
            color: #080
        }

        /* a markup attribute value */
        pre.prettyprint .dec, pre.prettyprint .var {
            color: #606
        }

        /* a declaration; a variable name */
        pre.prettyprint .fun {
            color: red
        }

        /* a function name */
    </style>
</head>
<body>
<?php if (\think\facade\App::isDebug()) { ?>
<?php foreach ($traces as $index => $trace) { ?>
<div class="exception">
    <div class="message">
        <div class="info">
            <div>
                <h2><?php echo "#{$index} [{$trace['code']}]" . sprintf('%s in %s', parse_class($trace['name']), parse_file($trace['file'], $trace['line'])); ?></h2>
            </div>
            <div><h1><?php echo nl2br(htmlentities($trace['message'])); ?></h1></div>
        </div>
    </div>
    <?php if (!empty($trace['source'])) { ?>
    <div class="source-code">
        <pre class="prettyprint lang-php"><ol
                    start="<?php echo $trace['source']['first']; ?>"><?php foreach ((array) $trace['source']['source'] as $key =>
                $value) { ?><li class="line-<?php echo " {$index}-"; echo $key + $trace['source']['first']; echo $trace['line'] === $key + $trace['source']['first'] ? ' line-error' : ''; ?>"><code><?php echo htmlentities($value); ?></code></li><?php } ?></ol></pre>
    </div>
    <?php }?>
    <div class="trace">
        <h2 data-expand="<?php echo 0 === $index ? '1' : '0'; ?>">Call Stack</h2>
        <ol>
            <li><?php echo sprintf('in %s', parse_file($trace['file'], $trace['line'])); ?></li>
            <?php foreach ((array) $trace['trace'] as $value) { ?>
            <li>
                <?php
                        // Show Function
                        if ($value['function']) {
                            echo sprintf(
                                'at %s%s%s(%s)',
                                isset($value['class']) ? parse_class($value['class']) : '',
                                isset($value['type'])  ? $value['type'] : '',
                                $value['function'],
                                isset($value['args'])?parse_args($value['args']):''
                            );
                        }

                        // Show line
                        if (isset($value['file']) && isset($value['line'])) {
                            echo sprintf(' in %s', parse_file($value['file'], $value['line']));
                        }
                        ?>
            </li>
            <?php } ?>
        </ol>
    </div>
</div>
<?php } ?>
<?php } else { ?>
<div class="exception">
    <div class="info"><h1><?php echo htmlentities($message); ?></h1></div>
</div>
<?php } ?>

<?php if (!empty($datas)) { ?>
<div class="exception-var">
    <h2>Exception Datas</h2>
    <?php foreach ((array) $datas as $label => $value) { ?>
    <table>
        <?php if (empty($value)) { ?>
        <caption><?php echo $label; ?><small>empty</small></caption>
        <?php } else { ?>
        <caption><?php echo $label; ?></caption>
        <tbody>
        <?php foreach ((array) $value as $key => $val) { ?>
        <tr>
            <td><?php echo htmlentities($key); ?></td>
            <td><?php echo_value($val); ?></td>
        </tr>
        <?php } ?>
        </tbody>
        <?php } ?>
    </table>
    <?php } ?>
</div>
<?php } ?>

<?php if (!empty($tables)) { ?>
<div class="exception-var">
    <h2>Environment Variables</h2>
    <?php foreach ((array) $tables as $label => $value) { ?>
    <table>
        <?php if (empty($value)) { ?>
        <caption><?php echo $label; ?><small>empty</small></caption>
        <?php } else { ?>
        <caption><?php echo $label; ?></caption>
        <tbody>
        <?php foreach ((array) $value as $key => $val) { ?>
        <tr>
            <td><?php echo htmlentities($key); ?></td>
            <td><?php echo_value($val); ?></td>
        </tr>
        <?php } ?>
        </tbody>
        <?php } ?>
    </table>
    <?php } ?>
</div>
<?php } ?>

<?php if (\think\facade\App::isDebug()) { ?>
<div class="copyright">
    <a title="官方网站" href="http://www.thinkphp.cn">ThinkPHP</a>
    <span>V<?php echo \think\facade\App::version(); ?></span>
    <span>{ 十年磨一剑-为API开发设计的高性能框架 }</span>
    <span>- <a title="官方手册" href="https://www.kancloud.cn/manual/thinkphp6_0/content">官方手册</a></span>
</div>
<script>
    function $(selector, node) {
        var elements;

        node = node || document;
        if (document.querySelectorAll) {
            elements = node.querySelectorAll(selector);
        } else {
            switch (selector.substr(0, 1)) {
                case '#':
                    elements = [node.getElementById(selector.substr(1))];
                    break;
                case '.':
                    if (document.getElementsByClassName) {
                        elements = node.getElementsByClassName(selector.substr(1));
                    } else {
                        elements = get_elements_by_class(selector.substr(1), node);
                    }
                    break;
                default:
                    elements = node.getElementsByTagName();
            }
        }
        return elements;

        function get_elements_by_class(search_class, node, tag) {
            var elements = [], eles,
                pattern = new RegExp('(^|\\s)' + search_class + '(\\s|$)');

            node = node || document;
            tag = tag || '*';

            eles = node.getElementsByTagName(tag);
            for (var i = 0; i < eles.length; i++) {
                if (pattern.test(eles[i].className)) {
                    elements.push(eles[i])
                }
            }

            return elements;
        }
    }

    $.getScript = function (src, func) {
        var script = document.createElement('script');

        script.async = 'async';
        script.src = src;
        script.onload = func || function (){};

        $('head')[0].appendChild(script);
    }

    ;(function () {
        var files = $('.toggle');
        var ol = $('ol', $('.prettyprint')[0]);
        var li = $('li', ol[0]);

        // 短路径和长路径变换
        for (var i = 0; i < files.length; i++) {
            files[i].ondblclick = function () {
                var title = this.title;

                this.title = this.innerHTML;
                this.innerHTML = title;
            }
        }

        (function () {
            var expand = function (dom, expand) {
                var ol = $('ol', dom.parentNode)[0];
                expand = undefined === expand ? dom.attributes['data-expand'].value === '0' : undefined;
                if (expand) {
                    dom.attributes['data-expand'].value = '1';
                    ol.style.display = 'none';
                    dom.innerText = 'Call Stack (展开)';
                } else {
                    dom.attributes['data-expand'].value = '0';
                    ol.style.display = 'block';
                    dom.innerText = 'Call Stack (折叠)';
                }
            };
            var traces = $('.trace');
            for (var i = 0; i < traces.length; i++) {
                var h2 = $('h2', traces[i])[0];
                expand(h2);
                h2.onclick = function () {
                    expand(this);
                };
            }
        })();

        $.getScript('//cdn.bootcdn.net/ajax/libs/prettify/r298/prettify.min.js', function () {
            prettyPrint();
        });
    })();
</script>
<?php } ?>
</body>
</html>
