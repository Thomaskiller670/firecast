require("rrpg.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");

function newafkbotPopup()
    __o_rrpgObjs.beginObjectsLoading();

    local obj = gui.fromHandle(_obj_newObject("popupForm"));
    local self = obj;
    local sheet = nil;

    rawset(obj, "_oldSetNodeObjectFunction", rawget(obj, "setNodeObject"));

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
        self:_oldSetNodeObjectFunction(nodeObject);
    end;

    function obj:setNodeDatabase(nodeObject)
        self:setNodeObject(nodeObject);
    end;

    _gui_assignInitialParentForForm(obj.handle);
    obj:beginUpdate();
    obj:setName("afkbotPopup");
    obj:setFormType("undefined");
    obj:setDataType("ambesek.afkbot");
    obj:setTitle("AfkBot");
    obj:setWidth(290);
    obj:setHeight(500);

    obj.tabControl1 = gui.fromHandle(_obj_newObject("tabControl"));
    obj.tabControl1:setParent(obj);
    obj.tabControl1:setAlign("client");
    obj.tabControl1:setName("tabControl1");

    obj.tab1 = gui.fromHandle(_obj_newObject("tab"));
    obj.tab1:setParent(obj.tabControl1);
    obj.tab1:setTitle("Opções");
    obj.tab1:setName("tab1");

    obj.checkBox1 = gui.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.tab1);
    obj.checkBox1:setField("botEnabled");
    obj.checkBox1:setLeft(10);
    obj.checkBox1:setTop(10);
    obj.checkBox1:setWidth(270);
    obj.checkBox1:setText("Habilitar AfkBot");
    obj.checkBox1:setName("checkBox1");

    obj.checkBox2 = gui.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox2:setParent(obj.tab1);
    obj.checkBox2:setField("autoEnable");
    obj.checkBox2:setLeft(10);
    obj.checkBox2:setTop(35);
    obj.checkBox2:setWidth(270);
    obj.checkBox2:setText("Autoligar quando ausente");
    obj.checkBox2:setName("checkBox2");

    obj.checkBox3 = gui.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox3:setParent(obj.tab1);
    obj.checkBox3:setField("spectator");
    obj.checkBox3:setLeft(10);
    obj.checkBox3:setTop(60);
    obj.checkBox3:setWidth(270);
    obj.checkBox3:setText("Alertar automaticamente espectadores?");
    obj.checkBox3:setName("checkBox3");

    obj.label1 = gui.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.tab1);
    obj.label1:setLeft(10);
    obj.label1:setTop(85);
    obj.label1:setWidth(190);
    obj.label1:setText("Tempo entre mensagens (min)");
    obj.label1:setHorzTextAlign("center");
    obj.label1:setName("label1");

    obj.edit1 = gui.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.tab1);
    obj.edit1:setLeft(200);
    obj.edit1:setTop(85);
    obj.edit1:setWidth(50);
    obj.edit1:setHeight(25);
    obj.edit1:setField("delay");
    obj.edit1:setType("number");
    obj.edit1:setMin(1);
    obj.edit1:setHorzTextAlign("center");
    obj.edit1:setName("edit1");

    obj.horzLine1 = gui.fromHandle(_obj_newObject("horzLine"));
    obj.horzLine1:setParent(obj.tab1);
    obj.horzLine1:setLeft(10);
    obj.horzLine1:setTop(115);
    obj.horzLine1:setWidth(270);
    obj.horzLine1:setName("horzLine1");

    obj.checkBox4 = gui.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox4:setParent(obj.tab1);
    obj.checkBox4:setField("stopDice");
    obj.checkBox4:setLeft(10);
    obj.checkBox4:setTop(120);
    obj.checkBox4:setWidth(270);
    obj.checkBox4:setText("Expulsar espectadores rolando dados.");
    obj.checkBox4:setName("checkBox4");

    obj.checkBox5 = gui.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox5:setParent(obj.tab1);
    obj.checkBox5:setField("stopLaugh");
    obj.checkBox5:setLeft(10);
    obj.checkBox5:setTop(145);
    obj.checkBox5:setWidth(270);
    obj.checkBox5:setText("Expulsar espectadores rindo.");
    obj.checkBox5:setName("checkBox5");

    obj.tab2 = gui.fromHandle(_obj_newObject("tab"));
    obj.tab2:setParent(obj.tabControl1);
    obj.tab2:setTitle("AfkBot");
    obj.tab2:setName("tab2");

    obj.messagesList = gui.fromHandle(_obj_newObject("recordList"));
    obj.messagesList:setParent(obj.tab2);
    obj.messagesList:setLeft(10);
    obj.messagesList:setTop(5);
    obj.messagesList:setWidth(270);
    obj.messagesList:setHeight(490);
    obj.messagesList:setField("messagesList");
    obj.messagesList:setName("messagesList");
    obj.messagesList:setTemplateForm("frmMessageItem");
    obj.messagesList:setLayout("vertical");
    obj.messagesList:setMinQt(1);

    obj.dataLink1 = gui.fromHandle(_obj_newObject("dataLink"));
    obj.dataLink1:setParent(obj.tab2);
    obj.dataLink1:setField("addMessage");
    obj.dataLink1:setName("dataLink1");

    obj.tab3 = gui.fromHandle(_obj_newObject("tab"));
    obj.tab3:setParent(obj.tabControl1);
    obj.tab3:setTitle("AutoKick");
    obj.tab3:setName("tab3");

    obj._e_event0 = obj.messagesList:addEventListener("onCompare",
        function (self, nodeA, nodeB)
            if nodeA.enabled and nodeB.enabled then 
            						return 0;
            					elseif nodeA.enabled then
            						return -1;
            					elseif nodeB.enabled then
            						return 1;
            					end;
        end, obj);

    obj._e_event1 = obj.dataLink1:addEventListener("onChange",
        function (self, field, oldValue, newValue)
            if sheet==nil then return end;
            					local addMessage = tonumber(sheet.addMessage) or 0;
            					if addMessage>0 then
            						sheet.addMessage = 0;
            						local item = self.messagesList:append();
            						item.enabled = false;
            					end;
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event1);
        __o_rrpgObjs.removeEventListenerById(self._e_event0);
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        if self.checkBox2 ~= nil then self.checkBox2:destroy(); self.checkBox2 = nil; end;
        if self.checkBox5 ~= nil then self.checkBox5:destroy(); self.checkBox5 = nil; end;
        if self.messagesList ~= nil then self.messagesList:destroy(); self.messagesList = nil; end;
        if self.tab3 ~= nil then self.tab3:destroy(); self.tab3 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.checkBox3 ~= nil then self.checkBox3:destroy(); self.checkBox3 = nil; end;
        if self.tab1 ~= nil then self.tab1:destroy(); self.tab1 = nil; end;
        if self.tabControl1 ~= nil then self.tabControl1:destroy(); self.tabControl1 = nil; end;
        if self.checkBox4 ~= nil then self.checkBox4:destroy(); self.checkBox4 = nil; end;
        if self.horzLine1 ~= nil then self.horzLine1:destroy(); self.horzLine1 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.tab2 ~= nil then self.tab2:destroy(); self.tab2 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.dataLink1 ~= nil then self.dataLink1:destroy(); self.dataLink1 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

     __o_rrpgObjs.endObjectsLoading();

    return obj;
end;

local _afkbotPopup = {
    newEditor = newafkbotPopup, 
    new = newafkbotPopup, 
    name = "afkbotPopup", 
    dataType = "ambesek.afkbot", 
    formType = "undefined", 
    formComponentName = "popupForm", 
    title = "AfkBot", 
    description=""};

afkbotPopup = _afkbotPopup;
rrpg.registrarForm(_afkbotPopup);
rrpg.registrarDataType(_afkbotPopup);

return _afkbotPopup;
