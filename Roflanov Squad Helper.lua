script_author("Roflanov")
script_name("FamHelper")
script_version('1.5')




local imgui = require 'imgui'
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
local bit = require 'bit'
local ffi = require 'ffi'
local requests = require 'requests'
local key = require 'vkeys'
local encoding = require 'encoding'
local tag = '[Family Helper]: {FFFFFF}'
local prefix = '[Roflanov Update]: {FFFFFF}'
local color1 = '0xFFFFFF'
local color2 = '0x303030'
local color3 = '0x2b27e8'
local fontsize = nil
encoding.default = 'CP1251'
u8 = encoding.UTF8
local mainIni = inicfg.load({
    form =
    {
        token = 'Не установлено',
        id = 'Не установлено',
        prefix = 'Не установлено'
    }
}, 'Roflanov-FamHelper.ini')
if not doesFileExist("moonloader/config/Roflanov-FamHelper.ini") then inicfg.save(mainIni, "Roflanov-FamHelper.ini") end
local cfgfile = 'moonloader/config/Roflanov-FamHelper.ini'
local FileName = 'moonloader/FamLog.txt'
local time = os.date('%H:%M:%S')
local data = os.date("%d.%m.%Y") 
local stateIni = inicfg.save(mainIni, cfgfile)
local sw, sh = getScreenResolution()

function loging(arg)
    data = os.date("%d.%m.%Y") 
    time = os.date('%H:%M:%S')
    timedata = data..' '..time
    local FileWrite = io.open(FileName, "a")
    FileWrite:write('['..timedata..'] '..arg..'\n')
    FileWrite:close()
end

local json_url = ''



imgui.Process = false
local mainmenuwindow = imgui.ImBool(false)
local menubar = 0

---------------------------------------------------

function main()
    if not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(0)
    end
    	autoupdate("https://raw.githubusercontent.com/slidbro/roflanov-fam-helper/main/update%2Cjson", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/slidbro/roflanov-fam-helper/main/update%2Cjson")
    	imgui.SwitchContext()
    	stylee()
    	thr = lua_thread.create_suspended(thread_function)
        sampAddChatMessage(tag.."скрипт {00c72b}успешно{FFFFFF} загружен!", color2)
        sampRegisterChatCommand("fh", mainmenu)

    while true do
    wait(0)
    	if mainmenuwindow.v == false then
    		imgui.Process = false
    	end
    	
    end
end


function mainmenu()
	mainmenuwindow.v = not mainmenuwindow.v
	imgui.Process = mainmenuwindow.v 
end


function imgui.OnDrawFrame()
	imgui.SetNextWindowSize(imgui.ImVec2(500, 200), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin('Roflanov Family Helper', mainmenuwindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar)
	imgui.BeginMenuBar()
	imgui.Text('')
	if imgui.MenuItem(u8'Информация') then menubar = 1 end
	imgui.Text('	      			')
	if imgui.MenuItem(u8'Настройки скрипта') then menubar = 2 end
	imgui.Text('	      		       ')
	if imgui.MenuItem(u8'Дополнительно') then menubar = 3 end
	imgui.EndMenuBar()
	
	if menubar == 3 then -- Дополнительно
		imgui.PushFont(fontsize)
		imgui.TextColored(imgui.ImVec4(rainbow(2)), '       			 Roflanov Squad')
		imgui.PopFont()
		imgui.Separator()
		imgui.Text(u8'Версия:1.0')
		imgui.Text(u8'Последнее обновление:15.06.2022')
		imgui.Separator()
		imgui.Text('')
		imgui.Text('         ')
		imgui.SameLine()
		if imgui.Button(u8'Выключить скрипт') then 
			thr:run('stopscript')
		end
		imgui.SameLine()
		if imgui.Button(u8'Перезапустить скрипт') then 
			thr:run('restartscript')
		end
		imgui.SameLine()
		if imgui.Button(u8'Проверить обновление') then 
			thr:run('obnova')
		end
	end

	imgui.End()
end





















function thread_function(opt)
	if opt == 'stopscript' then 
		sampAddChatMessage(tag..'скрипт выключен', color2)
		imgui.Process = false
		wait(1000)
		thisScript():unload()
	end

	if opt == 'restartscript' then
		imgui.Process = false
		sampAddChatMessage(tag..'скрипт перезагружается', color2)
		wait(2000)
		thisScript():reload()
	end

	if opt == 'obnova' then
		sampAddChatMessage(tag..'проверка обновлений запущена', color2)
		autoupdate("https://raw.githubusercontent.com/slidbro/roflanov-fam-helper/main/update%2Cjson", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/slidbro/roflanov-fam-helper/main/update%2Cjson")
		wait(3000)
		checkupd()

	end
end


function checkupd()
	if update == false then
		sampAddChatMessage(prefix..'Ваша версия {303030}'..thisScript().version.. ' {FFFFFF}актуальна, обновление не требуется',color2)
	elseif update == true then 
		sampAddChatMessage(prefix..'Обновление найдено')
	end
end

function rainbow(speed)
    local r = math.floor(math.sin(os.clock() * speed) * 127 + 128) / 255
    local g = math.floor(math.sin(os.clock() * speed + 2) * 127 + 128) / 255
    local b = math.floor(math.sin(os.clock() * speed + 4) * 127 + 128) / 255
    return r, g, b, 1
end

function imgui.BeforeDrawFrame()
    if fontsize == nil then
        fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
    end
end


function stylee()
	local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
	style.WindowRounding = 4
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = 4.0
    style.FrameRounding = 3
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0
    style.WindowPadding = imgui.ImVec2(4.0, 4.0)
    style.FramePadding = imgui.ImVec2(3.5, 3.5)
    style.ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
    
    		colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
            colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
            colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
            colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
            colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
            colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
            colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
            colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
            colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
            colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
            colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
            colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
            colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
            colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
            colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
            colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
            colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
            colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
            colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
            colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
            colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
            colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
            colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
            colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
            colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
            colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
            colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
            colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
            colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
            colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
            colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
            colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
            colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end


function autoupdate(json_url, tag, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'обнаружено обновление скрипта {303030}Family Helper{FFFFFF}'), color2)
                sampAddChatMessage((prefix..'запуск обновления с версии {303030}'..thisScript().version..'{FFFFFF} до версии {303030}'..updateversion), color2)
                wait(750)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'обновление скрипта на версию '..updateversion.. ' завершено!'), color2)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'{e81c1c}не удалось установить обновление'), color2)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
            end
          end
        else
          print('v'..thisScript().version..': Не удалось проверить обновление'..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end