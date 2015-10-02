-- Copyright (C) 2007-2015 by Ubaldo Porcheddu <ubaldo@eja.it>


function n(i) return tonumber(i) or 0 end

function s(v) 
 if type(v) == "number" then return tostring(v) elseif type(v) == "string" then return v else return "" end
end

function sf(...) return string.format(...) end


function gt(a,b) a=a or 0; b=b or 0; return tostring(a)>tostring(b) end		--!-
 
function lt(a,b) a=a or 0; b=b or 0; return tostring(a)<tostring(b) end	 	--!-
  
function eq(a,b) a=a or 0; b=b or 0; return tostring(a)==tostring(b) end	--!-	

function ge(a,b) a=a or 0; b=b or 0; return tostring(a)>=tostring(b) end	--!-
 
function le(a,b) a=a or 0; b=b or 0; return tostring(a)<=tostring(b) end	--!-



function la(key,value,language) 			
 if key and value and language then
  if not eja.i18n[language] then eja.i18n[language]={} end
  eja.i18n[language][key]=value
 else
  if not language then language=eja.lang end
  if eja.i18n[language] and eja.i18n[language][key] then
   return eja.i18n[language][key]
  else
   return key
  end
 end
end


function ejaXmlEncode(str) 
 if str then 
  return string.gsub(str, "([^%w%s])", function(c) return string.format("&#x%02X;", string.byte(c)) end)
 else 
  return ""
 end
end


function ejaUrlEscape(url)
 return url:gsub("%%(%x%x)",function(h) return string.char(tonumber(h,16)) end )
end



-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2

function ejaBase64Encode(data)
    b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function ejaBase64Decode(data)
    b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
