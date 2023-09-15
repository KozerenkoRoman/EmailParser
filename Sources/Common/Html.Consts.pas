{*******************************************************************************}
{                                                                               }
{              unit Html.Consts                                                 }
{                  v.3.0.0.6                                                    }
{              created 03/05/2012                                               }
{                                                                               }
{  Constants for working with Html-objects                                      }
{                                                                               }
{*******************************************************************************}
unit Html.Consts;

interface

{$REGION 'Region uses'}
uses
  Vcl.Graphics, System.UITypes;
{$ENDREGION}

type
  TWebColor = record
    Name  : string;
    Color : TColor;
  end;

resourcestring
  C_HTML_BREAK       = '<br>';         // line break
  C_HTML_LINE        = '<hr>';         // horizontal line

  C_HTML_NBSP        = '&nbsp;';       // inseparable space
  C_HTML_LESS        = '&lt;';         // <
  C_HTML_MORE        = '&gt;';         // >
  C_HTML_AMPERSAND   = '&amp;';        // &
  C_HTML_PERCENT     = '&#8470;';      // %

  C_HTML_BODY_OPEN   = '<body>';
  C_HTML_BODY_CLOSE  = '</body>';
  C_HTML_OPEN        = '<!DOCTYPE html><html lang="en">';
  C_HTML_CLOSE       = '</html>';
  C_HTML_HEAD_OPEN   = '<head><meta charset="UTF-8"><title>&nbsp;</title>';
  C_HTML_HEAD_CLOSE  = '</head>';
  C_HTML_TABLE_CLOSE = '</table>';
  C_HTML_TBODY_OPEN  = '<tbody>';
  C_HTML_TBODY_CLOSE = '</tbody>';
  C_HTML_BLANK       = 'about:blank';

const
  C_BG_COL_ERR   = '#FFFACD';
  C_BG_COL_HTML  = '#EAEAEA';
  C_BG_COL_MET   = '#E8F0F8';
  C_BG_COL_OBJ   = '#DEEAF0';
  C_BG_COL_TBODY = '#FBFBFB';
  C_BG_COL_TH    = '#85ACE3';
  C_BG_COL_THEAD = '#EAEAEA';
  C_BG_COL_TXT   = '#F5F5F5';
  C_BG_COL_WARN  = '#F5F5F5';

  C_HTML_STYLE_OPEN  = '<style>';
  C_HTML_STYLE_CLOSE = '</style>';

  C_STYLE_XML_CODE = '.xml-code{}';
  C_STYLE_SQL_CODE = '.sql-code{' +
                                'padding: 0 15px 0 15px;' +
                                'background-color: white;' +
                                '}';
  C_STYLE_HR       = 'hr{' +
                        'border:1px solid gray' +
                        '}';
  C_STYLE_CENTER   = '.center {text-align: center;} ';

  C_STYLE_HTML     = 'html{' +
//                           'background:' + C_BG_COL_HTML + ';' +
                          '}';

  C_STYLE_BODY     = 'body{' +
                          '}';

  C_STYLE_H1       = 'h1{'                              +
                         'text-align:center;'           +
                         '}';

  C_STYLE_H2       = 'h2{'                              +
                         'text-align:center;'           +
                         'font-weight:bold;'            +
                         'font-size:140%;'              +
                         '}';

  C_STYLE_CAPTION  = 'caption{'                         +
                              'margin:0.5em;'           +
                              'font-weight:bold;'       +
                              'font-size:110%;'         +
                              'text-align:center'       +
                              '}';

  C_STYLE_TABLE    = 'table{'                           +
                            'border-collapse:collapse;' +
                            'display:table;'            +
                            'table-layout:auto;'        +
                            'width:100%;'               +
                           '}';

  C_STYLE_THEAD    = 'thead{'                           +
                            'background:' + C_BG_COL_THEAD + ';' +
                           '}';

  C_STYLE_TD       = 'td{'                              +
                         'border:1px solid gray;'       +
                         '}';

  C_STYLE_TH       = 'th{'                              +
                         'border:1px solid gray;'       +
//                         'background:' + C_BG_COL_TH + ';' +
                        '}';

  C_STYLE_TR       = 'tr{'                              +
                         'border: 1px solid gray;'      +
                         '}';

  C_STYLE_TBODY    = 'tbody{'                           +
                            'background:' + C_BG_COL_TBODY + ';' +
                            '}';

  C_STYLE_TABLE_TR = '.err{' +
                           'color:red;' +
                           'background:' + C_BG_COL_ERR + ';'+
                           'vertical-align:baseline}'   +    // table row with error
                     '.met{' +
                           'color:navy;' +
                           'background:' + C_BG_COL_MET + ';' +
                           'vertical-align:baseline}'  +    // table row with method
                     '.obj {' +
                            'color:black;' +
                            'background:' + C_BG_COL_OBJ + ';' +
                            'vertical-align:baseline}' +    // table row with object
                     '.warn {' +
                             'color:maroon;' +
                             'background:' + C_BG_COL_WARN + ';' +
                             'vertical-align:baseline}' +  // table row with warning
                     '.txt {' +
                            'color:black;' +
                            'background:' + C_BG_COL_TXT + ';' +
                            'vertical-align:baseline}';     // table row with simple text


  //This style adds an image to an html document without an external file:
  //div.exit{width:16px;height:16px;border:none;background-image:url(data:image/png;base64, ...);}
  //image to base64 converter: http://websemantics.co.uk/online_tools/image_to_data_uri_convertor/
  //use in body of html: <div class="exit" src=""/>

  //image of arrow to right
  C_STYLE_IMG_ENTER = '.img-enter{' +
                      'min-width: 20px;' +
                      'background-position: left 50% bottom 50%;' +
                      'background-repeat:no-repeat;' +
                      'background-image:' +
                      'url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgS' +
                      'W1hZ2VSZWFkeXHJZTwAAAKfSURBVHjaYvz//z8DJQAggFhgDDaz2ccVJHgt3rz8cu/9+z9FDGKCGxnYeRkY/rMxMLBzMTDwANlMnAwMzNwMDNxcDP9n84P1AQQQ' +
                      'E8wA9v8MBqV5Vgyz+9yVlFRFNjB8+DWV4e8/MQZG/C4ACCC4Af+APnn3n4lB20qWYU6/J0NYoHoW089/exn+/vfDZwBAAMEN+MHA+u7I8VcM+6/+Y3jwn5shM8O' +
                      'UoavCREdChGstw+//k4A2cGIzACCAGGGByGi5xJLhF/MEFV05Myt3PQY+IV4GI2kGBsH/3xlmrnnKsOv010v/2LmyGTh5jjDwAMNgFiQMAAIIYYDNMiDBwcvwg6' +
                      'mSW0IoV8lAhYdLQpJBV4aRwVvzH8OFax8YJq/7/OHdF5aZDMI8jcBA/A7SBxBAaAawQzAnrxEDM/t0bjERMxYxeQZeblaGRFsGBlX+3wwzdnxlOHaX6cT/eXyWI' +
                      'H0AAQSPRgYxDWBIMkAx4ydeLsbv7CzMDB9//Gf4+JuBYdYRBgZPbWag2RwMTKwM8PAACCAWtDDhZvj9L0dCgqvUQFtM+M53YYZvXxgZlET/M/z5+Yth2a4/P379' +
                      'YJrHwM1cBdMAEEAIA/7/12D8zzBdUUXQQVJRhuHcO3aG70DfSQn+ZXj36hfD2w9/7/77z5zHwMa4HaQapg0ggJBcwLRdQEZM4Y+YJMPpZ0wMPBwMDHysvxiePP7' +
                      'J8OMX82IGFpY8oPc+gL2IBAACCG4AIxuHxDdmAYbvX5kYBDj/Mvz58Z3h2cu/9/4zsjQysDAuwpWQAAIIbsB/FnYGJiYmBm7GXwyf3n4H2sqwjIGZuR4odQdfSg' +
                      'QIIHhKZGRmv/X3+3eG92+/vgRqjmVgYY4G5oM7DAQyK0AAMVKanQECDADMwNCYef7LugAAAABJRU5ErkJggg==);} ';
  //image of arrow to left
  C_STYLE_IMG_EXIT  = '.img-exit{' +
                      'min-width: 20px;' +
                      'background-position: left 50% bottom 50%;' +
                      'background-repeat:no-repeat;' +
                      'background-image:' +
                      'url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgS' +
                      'W1hZ2VSZWFkeXHJZTwAAAKbSURBVHjaYvz//z8DJQAggFhgDEajmQwMP34zMLADhViZGRi+AdmMQAl2VgaGf/8YGN5/9+IX5e4XleRTe/j619lfx2JNQPoAAogJ' +
                      'v/lAE/7+EwJqniCnKLhpZqerWmWRPQMHM7s2TAVAAOE34O8/d6Zvv/YG+mvmz50ayGzgqMDw7j8Tw19mNrgSgABiwbQUaOu//2wMv/+2iYpw5RRnWbJbOGgw3Pv' +
                      'KxHD76j+GIyffMPxkYPkIUw4QQCwYmn/8MWP4/We6s4OSUVamFcMXLmGGtdcYGD69+cRwYs8VhpvXX59l4GQvhWkBCCBkAzgZvv2q5BfiyswptBIxddRl2HGLhe' +
                      'H8/X8M357cZ7h/7ub3L2+/T2Pg525iYGH6BNMEEEAIA/783WVur2KTmWbF8OifMEP+SmDAf/jO8P/uGYbPr96cZ2BmyWLgZD3BwACKdkTUAwQQ3AAmRkZOTj4Oh' +
                      'oNP2Bl23mVgeP4OKPbzPwM/EyMDHzfHj09/uT4ycHAzMHABMTs33ACAAILHwj8WJrsDO25MXDJx61fO93cZNGT+MXDyczHw61kxWDvoWEqLcxwDhk0t0HIe5GAD' +
                      'CCBENP5n+AZ0YuHv378C7x07f/P1hQsMEtzfGN7/ZWI4/U2WQc5IV0BFQ6SJieH/NmAs6cK0AQQQajr4D4QszLv/s7Gbvnnyes7jMxf/8/x8A4yd/wznnnMx/BJ' +
                      'RZhCUErdlYGLaCtMCEEDYExIj42egotSfP/5GPb3x4Pa/t08ZBLn+MLz6wsjwmYGXgZGNQxSmFCCA8KdERsYV/5nYXN69/Dz/w9OXDDxMwCTEwsjwn5kDrgQggJ' +
                      'gIZjcmhkdAXUk/vv+LeP/669M/v34zMLKy3odJAwQQI6XZGSDAABOQ3NieFWOEAAAAAElFTkSuQmCC);} ';
  //red cross image - error
  C_STYLE_IMG_ERR   = '.img-err{' +
                      'min-width: 20px;' +
                      'background-position: left 50% bottom 50%;' +
                      'background-repeat:no-repeat;' +
                      'background-image:' +
                      'url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgS' +
                      'W1hZ2VSZWFkeXHJZTwAAAP/SURBVHjaYiyXlGT4/vu3vIag4BKh//8NL3/7lvL/378VbP/+MbD+/8/ABKQZgfjv378MzAwM3hri4st//vt39+G9e1GcTEzXAQKI' +
                      '2YKHR16Oh2dJpLm5jZmmJtu3O3e8n/7794Dx///LLAwMDECa4T8I//vnoy8ktMw7NZVPXl9f4vWdOxYfP3w4ChBAzDGKirtiTEwshfPzGRhCQxmUnjxh/Xfxoud' +
                      'TJqZ7TAwMV0AGAK33MmZnX+YUFcXHmpfHwK6uziDPyyv1/sULB4AAYhHm4NAVEhZmYODmZmD49ImBJSuLwe7LF86/q1fPPs/N/Quo+ZPunz8rbIKDednj4hgY3r' +
                      '0DGcjAIy/PICQmpgYQQMzq///f//nhg4fykydsjBISQDczMrAYGTFIPX/O9uvixSChX78iHNzcuHiBBoM0Mnz4wPD/1CmGM0uW/Lx06FAhQAAx27CzX3706dN9p' +
                      'tevveRevWJlAhkCVMhiYMAg/PQpk4y4OIsAUDMjVPO/M2cYLmzc+OfE0aNF///8mQYQQMx2PDwM/3//vvLkx48Hf1688JJ79oyFWUQEHHgcGhoMXPr6DEygQHz7' +
                      'luHvyZMMZ7Zv/3PqwoWCf3//TmUBuhYggJhtgX5nBIY2w58/l1/8/Hn15+vXQZJv3zKzgQxhYmJg/POH4f/HjwzfgZrP7t//9/ydO0n//v2bwwyKIaABAAHEwv/' +
                      '1KwNQgOEfUPF/NrYP/7i4/n0GOvPLixcMYO8AwV+gGlAA/2Vh+Qe07AMbUAyEQekEIICYXVlZGf6CbOHg8DGWlV1j9fEj91egcz++fs3w9v59ho9A/BvodyY2Ng' +
                      'Y5GRlmFkHBgNevXj1ggKYTgABiAiYQhv/s7F4WampL7T594v0FtPk/SAKI+YFOFABqZObgYPgPdOFPoCv05OQ4jaytZzMyM0eC1AEEEAsjO7ufiabmEru3b3m/P' +
                      '3rE8JsBAniALnvEyvrvDyPjPyVmZpY/QOf+BeJfwHSgq6LCCfTu7JsHD7ICBBCLhpbWEvfv33l/3r7N8AtqMw8XF8MdTs6fF79/zwDG0EeWv38Xq3BwcP8FuugP' +
                      'UP73s2cMJiYm3MBwmwkQQEw/v3599AXoTCagjaDY4BIQYHgoJPTn3LdvxX///VsAdOb6q+/fpz76+vU7JzDGQFEKCo8fv34xfH///gVAADGbffp08BUPj7mCmJg' +
                      'ULzMzw2V+/j9nXr0qAAbsVGYgHxzFf/9eef3p0wNWLi5PGTk51v/AKD5+9OiNJ+fPxwIEELMnG9vrD2/eHP7CyWn5hotL+PLjx/l/gCmMCZQGgE5mAEUVMKBBof' +
                      '7p/fsHf5iYPB49ePDg4fXr8cyMjCcBAgwAkC29pEiNXvgAAAAASUVORK5CYII=);} ';

  C_STYLE = C_HTML_STYLE_OPEN +
            C_STYLE_HTML +
            C_STYLE_BODY +
            C_STYLE_H1 +
            C_STYLE_H2 +
            C_STYLE_TABLE +
            C_STYLE_THEAD +
            C_STYLE_TD +
            C_STYLE_TH +
            C_STYLE_TR +
            C_STYLE_HR +
            C_STYLE_TABLE_TR +
            C_STYLE_CAPTION +
            C_STYLE_CENTER +
            C_STYLE_IMG_ENTER +
            C_STYLE_IMG_ERR +
            C_STYLE_IMG_EXIT +
            C_STYLE_SQL_CODE +
            C_STYLE_XML_CODE +
            C_HTML_STYLE_CLOSE;

  arrWebColors: array [1 .. 138] of TWebColor = (
    (Name: 'Snow'                 ; Color: TColors.Snow),
    (Name: 'FloralWhite'          ; Color: TColors.FloralWhite),
    (Name: 'LavenderBlush'        ; Color: TColors.LavenderBlush),
    (Name: 'OldLace'              ; Color: TColors.OldLace),
    (Name: 'Ivory'                ; Color: TColors.Ivory),
    (Name: 'CornSilk'             ; Color: TColors.CornSilk),
    (Name: 'Beige'                ; Color: TColors.Beige),
    (Name: 'AntiqueWhite'         ; Color: TColors.AntiqueWhite),
    (Name: 'Wheat'                ; Color: TColors.Wheat),
    (Name: 'AliceBlue'            ; Color: TColors.AliceBlue),
    (Name: 'GhostWhite'           ; Color: TColors.GhostWhite),
    (Name: 'Lavender'             ; Color: TColors.Lavender),
    (Name: 'Seashell'             ; Color: TColors.Seashell),
    (Name: 'LightYellow'          ; Color: TColors.LightYellow),
    (Name: 'PapayaWhip'           ; Color: TColors.PapayaWhip),
    (Name: 'NavajoWhite'          ; Color: TColors.NavajoWhite),
    (Name: 'Moccasin'             ; Color: TColors.Moccasin),
    (Name: 'Burlywood'            ; Color: TColors.Burlywood),
    (Name: 'Azure'                ; Color: TColors.Azure),
    (Name: 'Mintcream'            ; Color: TColors.Mintcream),
    (Name: 'Honeydew'             ; Color: TColors.Honeydew),
    (Name: 'Linen'                ; Color: TColors.Linen),
    (Name: 'LemonChiffon'         ; Color: TColors.LemonChiffon),
    (Name: 'BlanchedAlmond'       ; Color: TColors.BlanchedAlmond),
    (Name: 'Bisque'               ; Color: TColors.Bisque),
    (Name: 'PeachPuff'            ; Color: TColors.PeachPuff),
    (Name: 'Tan'                  ; Color: TColors.Tan),
    (Name: 'Yellow'               ; Color: TColors.Yellow),
    (Name: 'DarkOrange'           ; Color: TColors.DarkOrange),
    (Name: 'Red'                  ; Color: TColors.Red),
    (Name: 'DarkRed'              ; Color: TColors.DarkRed),
    (Name: 'Maroon'               ; Color: TColors.Maroon),
    (Name: 'IndianRed'            ; Color: TColors.IndianRed),
    (Name: 'Salmon'               ; Color: TColors.Salmon),
    (Name: 'Coral'                ; Color: TColors.Coral),
    (Name: 'Gold'                 ; Color: TColors.Gold),
    (Name: 'Tomato'               ; Color: TColors.Tomato),
    (Name: 'Crimson'              ; Color: TColors.Crimson),
    (Name: 'Brown'                ; Color: TColors.Brown),
    (Name: 'Chocolate'            ; Color: TColors.Chocolate),
    (Name: 'SandyBrown'           ; Color: TColors.SandyBrown),
    (Name: 'LightSalmon'          ; Color: TColors.LightSalmon),
    (Name: 'LightCoral'           ; Color: TColors.LightCoral),
    (Name: 'Orange'               ; Color: TColors.Orange),
    (Name: 'OrangeRed'            ; Color: TColors.OrangeRed),
    (Name: 'Firebrick'            ; Color: TColors.Firebrick),
    (Name: 'SaddleBrown'          ; Color: TColors.SaddleBrown),
    (Name: 'Sienna'               ; Color: TColors.Sienna),
    (Name: 'Peru'                 ; Color: TColors.Peru),
    (Name: 'DarkSalmon'           ; Color: TColors.DarkSalmon),
    (Name: 'RosyBrown'            ; Color: TColors.RosyBrown),
    (Name: 'PaleGoldenrod'        ; Color: TColors.PaleGoldenrod),
    (Name: 'LightGoldenrodYellow' ; Color: TColors.LightGoldenrodYellow),
    (Name: 'Olive'                ; Color: TColors.Olive),
    (Name: 'ForestGreen'          ; Color: TColors.ForestGreen),
    (Name: 'GreenYellow'          ; Color: TColors.GreenYellow),
    (Name: 'Chartreuse'           ; Color: TColors.Chartreuse),
    (Name: 'LightGreen'           ; Color: TColors.LightGreen),
    (Name: 'Aquamarine'           ; Color: TColors.Aquamarine),
    (Name: 'SeaGreen'             ; Color: TColors.SeaGreen),
    (Name: 'GoldenRod'            ; Color: TColors.GoldenRod),
    (Name: 'Khaki'                ; Color: TColors.Khaki),
    (Name: 'OliveDrab'            ; Color: TColors.OliveDrab),
    (Name: 'Green'                ; Color: TColors.Green),
    (Name: 'YellowGreen'          ; Color: TColors.YellowGreen),
    (Name: 'LawnGreen'            ; Color: TColors.LawnGreen),
    (Name: 'PaleGreen'            ; Color: TColors.PaleGreen),
    (Name: 'MediumAquamarine'     ; Color: TColors.MediumAquamarine),
    (Name: 'MediumSeaGreen'       ; Color: TColors.MediumSeaGreen),
    (Name: 'DarkGoldenRod'        ; Color: TColors.DarkGoldenRod),
    (Name: 'DarkKhaki'            ; Color: TColors.DarkKhaki),
    (Name: 'DarkOliveGreen'       ; Color: TColors.DarkOliveGreen),
    (Name: 'Darkgreen'            ; Color: TColors.Darkgreen),
    (Name: 'LimeGreen'            ; Color: TColors.LimeGreen),
    (Name: 'Lime'                 ; Color: TColors.Lime),
    (Name: 'SpringGreen'          ; Color: TColors.SpringGreen),
    (Name: 'MediumSpringGreen'    ; Color: TColors.MediumSpringGreen),
    (Name: 'DarkSeaGreen'         ; Color: TColors.DarkSeaGreen),
    (Name: 'LightSeaGreen'        ; Color: TColors.LightSeaGreen),
    (Name: 'PaleTurquoise'        ; Color: TColors.PaleTurquoise),
    (Name: 'LightCyan'            ; Color: TColors.LightCyan),
    (Name: 'LightBlue'            ; Color: TColors.LightBlue),
    (Name: 'LightSkyBlue'         ; Color: TColors.LightSkyBlue),
    (Name: 'CornFlowerBlue'       ; Color: TColors.CornFlowerBlue),
    (Name: 'DarkBlue'             ; Color: TColors.DarkBlue),
    (Name: 'Indigo'               ; Color: TColors.Indigo),
    (Name: 'MediumTurquoise'      ; Color: TColors.MediumTurquoise),
    (Name: 'Turquoise'            ; Color: TColors.Turquoise),
    (Name: 'Cyan'                 ; Color: TColors.Cyan),
    (Name: 'PowderBlue'           ; Color: TColors.PowderBlue),
    (Name: 'SkyBlue'              ; Color: TColors.SkyBlue),
    (Name: 'RoyalBlue'            ; Color: TColors.RoyalBlue),
    (Name: 'MediumBlue'           ; Color: TColors.MediumBlue),
    (Name: 'MidnightBlue'         ; Color: TColors.MidnightBlue),
    (Name: 'DarkTurquoise'        ; Color: TColors.DarkTurquoise),
    (Name: 'CadetBlue'            ; Color: TColors.CadetBlue),
    (Name: 'DarkCyan'             ; Color: TColors.DarkCyan),
    (Name: 'Teal'                 ; Color: TColors.Teal),
    (Name: 'DeepskyBlue'          ; Color: TColors.DeepskyBlue),
    (Name: 'DodgerBlue'           ; Color: TColors.DodgerBlue),
    (Name: 'Blue'                 ; Color: TColors.Blue),
    (Name: 'Navy'                 ; Color: TColors.Navy),
    (Name: 'DarkViolet'           ; Color: TColors.DarkViolet),
    (Name: 'DarkOrchid'           ; Color: TColors.DarkOrchid),
    (Name: 'Magenta'              ; Color: TColors.Magenta),
    (Name: 'Fuchsia'              ; Color: TColors.Fuchsia),
    (Name: 'DarkMagenta'          ; Color: TColors.DarkMagenta),
    (Name: 'MediumVioletRed'      ; Color: TColors.MediumVioletRed),
    (Name: 'PaleVioletRed'        ; Color: TColors.PaleVioletRed),
    (Name: 'BlueViolet'           ; Color: TColors.BlueViolet),
    (Name: 'MediumOrchid'         ; Color: TColors.MediumOrchid),
    (Name: 'MediumPurple'         ; Color: TColors.MediumPurple),
    (Name: 'Purple'               ; Color: TColors.Purple),
    (Name: 'DeepPink'             ; Color: TColors.DeepPink),
    (Name: 'LightPink'            ; Color: TColors.LightPink),
    (Name: 'Violet'               ; Color: TColors.Violet),
    (Name: 'Orchid'               ; Color: TColors.Orchid),
    (Name: 'Plum'                 ; Color: TColors.Plum),
    (Name: 'Thistle'              ; Color: TColors.Thistle),
    (Name: 'HotPink'              ; Color: TColors.HotPink),
    (Name: 'Pink'                 ; Color: TColors.Pink),
    (Name: 'LightSteelBlue'       ; Color: TColors.LightSteelBlue),
    (Name: 'MediumSlateBlue'      ; Color: TColors.MediumSlateBlue),
    (Name: 'LightSlateGray'       ; Color: TColors.LightSlateGray),
    (Name: 'White'                ; Color: TColors.White),
    (Name: 'Lightgrey'            ; Color: TColors.Lightgrey),
    (Name: 'Gray'                 ; Color: TColors.Gray),
    (Name: 'SteelBlue'            ; Color: TColors.SteelBlue),
    (Name: 'SlateBlue'            ; Color: TColors.SlateBlue),
    (Name: 'SlateGray'            ; Color: TColors.SlateGray),
    (Name: 'WhiteSmoke'           ; Color: TColors.WhiteSmoke),
    (Name: 'Silver'               ; Color: TColors.Silver),
    (Name: 'DimGray'              ; Color: TColors.DimGray),
    (Name: 'MistyRose'            ; Color: TColors.MistyRose),
    (Name: 'DarkSlateBlue'        ; Color: TColors.DarkSlateBlue),
    (Name: 'DarkSlategray'        ; Color: TColors.DarkSlategray),
    (Name: 'Gainsboro'            ; Color: TColors.Gainsboro),
    (Name: 'DarkGray'             ; Color: TColors.DarkGray)
  );

implementation

end.
