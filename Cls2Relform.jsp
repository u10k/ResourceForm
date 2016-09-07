﻿<%@ include file='/main/head.jsp' %>
<script src="<%=eafapppath %>/main/UserInterface/control.js" type="text/javascript"></script>
<script src="<%=eafapppath %>/main/UserInterface/form.js" type="text/javascript"></script>
<div data-options="region:'west'" style="width: 260px;">
    <form id="uie_div_form" style=" height:100%; ">
    </form>
</div>
<div data-options="region: 'center',title: '' " style="padding: 1px;">
    <iframe id="uie_ifm_rel" name="uie_ifm_rel" src="" frameborder="0" style="border: 0;
        width: 100%; height: 99%;"></iframe>
</div>
<script type="text/javascript">
    var clsid = eaf.getUrlParam('clsid');  //类ID   
    var uiid = eaf.getUrlParam('uiid'); //表单界面id
    var objid = eaf.getUrlParam('objid'); //对象ID
    var divform = $('#uie_div_form');
    var eafform;
    $(function () {
        var param = {};
        param.groups = ctl.getAttrGroupByCls(clsid); //获取属性组
        param.attrs = ctl.getAttrExByCls(clsid); //获取属性
        param.tools = ctl.getFormOpersByCls(clsid, uiid); //获取操作 
        for (var i = 0; i < param.tools.length; i++) {
            if (param.tools[i].EAF_ID == "C8D374979B252F9E9D0EF19500DE05CB")
                param.tools[i].EAF_EVENT = "uie_frm_clsui()";//	"CLSUI:01CA6C0A56BD451DA50806E617C5E347,B77C8CD23AE4EF5DBBD243579F82C9A9,id=[objid]"
            if (param.tools[i].EAF_ID == "93BA2A79E810E59E8F48738B2AC709B7")
                param.tools[i].EAF_EVENT = "uie_frm_clsoper()";//	"CLSUI:01CA6C0A56BD451DA50806E617C5E347,B77C8CD23AE4EF5DBBD243579F82C9A9,id=[objid]"
        }
        var fromobj = ctl.getObjDefaultById(objid, clsid, param.attrs); //获取单个对象（包括默认值）
        var frompclsid = ""; //添加情况下，父类ID
        if (!fromobj.EAF_TYPE) {//如果类型为空，表示是类，要隐藏的关联相关列
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_TYPE").EAF_FORMSHOW = 'N';
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_LEFTCLASSID").EAF_FORMSHOW = 'N';
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_LEFTCLASSNAME").EAF_FORMSHOW = 'N';
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_RIGHTCLASSID").EAF_FORMSHOW = 'N';
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_RIGHTCLASSNAME").EAF_FORMSHOW = 'N';
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_RELTYPE").EAF_FORMSHOW = 'N';
            if (!fromobj.EAF_NAME) { frompclsid = fromobj.EAF_PID; } //添加
        }
        else {
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_PERSIST").EAF_FORMSHOW = 'N';
            eaf.findArray(param.attrs, "EAF_CNAME", "EAF_VERSIONTYPE").EAF_FORMSHOW = 'N';
            if (!fromobj.EAF_NAME) { frompclsid = '1F31E3CDC454FF32CCCE6EACC4E7EBFE'; } //关联暂时默认不继承  //添加
            if (objid == '1F31E3CDC454FF32CCCE6EACC4E7EBFE') {
                eaf.findArray(param.attrs, "EAF_CNAME", "EAF_LEFTCLASSID").EAF_FORMSHOW = 'N';
                eaf.findArray(param.attrs, "EAF_CNAME", "EAF_LEFTCLASSNAME").EAF_FORMSHOW = 'N';
                eaf.findArray(param.attrs, "EAF_CNAME", "EAF_RIGHTCLASSID").EAF_FORMSHOW = 'N';
                eaf.findArray(param.attrs, "EAF_CNAME", "EAF_RIGHTCLASSNAME").EAF_FORMSHOW = 'N';
                eaf.findArray(param.attrs, "EAF_CNAME", "EAF_TYPE").EAF_FORMSHOW = 'N';
                eaf.findArray(param.attrs, "EAF_CNAME", "EAF_RELTYPE").EAF_FORMSHOW = 'N';
            }
        }
        //显示类ID
        var eaf_id=eaf.findArray(param.attrs, "EAF_CNAME", "EAF_ID");
        eaf_id.EAF_FORMSHOW = 'Y';
        eaf_id.EAF_NOEDIT='Y';
        eaf_id.EAF_CTLTYPE='noedit';
        eafform = new eaf_form(divform, param, clsid, objid, fromobj);
        //设置属性列表
        var relurl = 'Cls2RelAttr.jsp?uiid=8E484453AC6F6ABE08678490ACEA397E&clsid=DD9D7BCD45E2B002B64D372A04F31798&fromclsid=' + objid + '&frompclsid=' + frompclsid;
        window.frames["uie_ifm_rel"].location.href = relurl;
        //父类有版本，子类和父类一致   
        var pfromobj = eaf.getObjById(fromobj.EAF_PID, clsid); //获取父对象
        if (pfromobj.EAF_VERSIONTYPE != '0') {
            $("#EAF_VERSIONTYPE").combobox('setValue', pfromobj.EAF_VERSIONTYPE);
            $("#EAF_VERSIONTYPE").combobox('disable');
        }
        //
        var EAF_LEFTCLASSID = eaf.getUrlParam('EAF_LEFTCLASSID');
        if (EAF_LEFTCLASSID == "(EAF_ID)" && !(fromobj && fromobj.EAF_LEFTCLASSID != "(EAF_ID)")) {
            $("#EAF_LEFTCLASSID").combobox('clear');
        }
        if (frompclsid=="(EAF_ID)") {  eaf.msg("请先选择父类。"); }
    });
    //删除当前类
    function uie_frm_delete() {
        $.messager.confirm('确认对话框', '您确定要删除这个类吗？', function (r) {
            if (r) {
                var rs = eaf.readData("DataModel", "DeleteClass", { clsid: objid });
                if (rs.EAF_ERROR) {
                    eaf.msg(rs.EAF_ERROR);
                    return;
                }
                //更新页面数据
                var ifmtree = parent.frames["ifm8A0553ADAE0DEFB9299263A63E463655"];
                eaf.getIframWin(ifmtree).eaftree.reload(objid);
                parent.closeSelTab();
            }
        });
    }
    //保存表单数据
    var abc="huwenzhe";
    function uie_frm_save() {
    var data=eaf.getIframWin(window.frames["uie_ifm_rel"]).data;
    var deleteObjects=eaf.getIframWin(window.frames["uie_ifm_rel"]).deleteObjects;
    if(data){
         eaf.saveData('ObjectService', 'SaveObjects', data, '');
    }else{
         eaf.saveObjects(resClsId, [], [], deleteObjects, function (arg) {
         alert("保存成功");
         });
    }
    debugger;//2
		top.overrideAttrs=window.frames["uie_ifm_rel"].getSaveJson();
		// 是否存在被覆盖的属性
    	var isExistAttrOverride=eaf.readData('DataModel', 'IsExistAttrOverride',{'clsId':objid});     	
		if(isExistAttrOverride.isExistAttrOverride=="1"&&(eaf.strToJson(top.overrideAttrs.updateObjects).length>0)){ 		
       		//选择要传递的属性窗口
   	    	ctl.openDialog("main/DataModel/AttrSynchronize.jsp", "属性传递", true,function(v){
   	    		var cacheData=window.frames["uie_ifm_rel"].dataCache;
   	    		// 过滤未修改的元属性
   	    		eaf.getChangeAttrs(cacheData,v,'EAF_ID',['EAF_ID','EAF_CLASSID','EAF_PATTRID','EAF_CNAME','IsOverride']);
   	    		uie_frm_save2(eaf.jsonToStr(v))
   	    	}, 800,590);   		        	
    	}else{
    		uie_frm_save2(top.overrideAttrs.updateObjects);
    	}
    }
  	//保存表单数据
    function uie_frm_save2(r){
    debugger;//2
    	if (!divform.form('validate')) {
            return;
        }
        // 类表单json
        var formJson = eaf.jsonToStr(divform.serializeObject());
        var gridJson = top.overrideAttrs;
        // 组织参数
        var data = {
            clsid: objid,
            classObj: formJson,
            insertAttrs: gridJson.insertObjects,
            updateAttrs: r,
            deleteAttrs: gridJson.deleteObjects,
            arg:eaf.jsonToStr({'isCheckOverride':'1'})
        };
        eaf.saveClass2(data, function (result) {
        	if (result.EAF_ERROR) {
            	if(result.EAF_ERROR.includes('被子类覆盖')){
            		data.arg=eaf.jsonToStr({'isCheckOverride':'0'})
    	        	$.messager.confirm('确认对话框', '被删除的属性中存在被子类覆盖的属性，您确定要删除吗类吗？', function (r) {
    	                if (r) {     
    	                	eaf.saveClass2(data, function (result) {
    	                		//更新页面数据
    	                        var ifmtree = parent.frames["ifm8A0553ADAE0DEFB9299263A63E463655"];
    	                        eaf.getIframWin(ifmtree).eaftree.reload(objid);
    	                        parent.updateTab({ title: $("#EAF_NAME").textbox('getValue') });
    	                	})
    	                }
    	            }); 
    	        	return;
            	}else{
            		$.messager.alert('提示', result.EAF_ERROR);
            		return;                		           		
            	}             
      	 	}
            //更新页面数据
            var ifmtree = parent.frames["ifm8A0553ADAE0DEFB9299263A63E463655"];
            eaf.getIframWin(ifmtree).eaftree.reload(objid);
            parent.updateTab({ title: $("#EAF_NAME").textbox('getValue') });
        });       
    }
    //返回选择行数据
    function getResult() {
        return divform.serializeObject();
    };
    //打开“界面”
    function uie_frm_clsui()
    {        //http://localhost:8083/main/UserInterface/datagrid.jsp?clsid=01CA6C0A56BD451DA50806E617C5E347&uiid=B77C8CD23AE4EF5DBBD243579F82C9A9&id=14C2CBACE5F54D9E7AFC9320C16AD82F
        window.open(eaf.getEafAppPath() + '/main/DataModel/ClsUI.jsp?clsid=01CA6C0A56BD451DA50806E617C5E347&uiid=B77C8CD23AE4EF5DBBD243579F82C9A9&id=' + objid);
    }
    //打开“操作”
    function uie_frm_clsoper() {        //http://localhost:8083/main/UserInterface/datagrid.jsp?clsid=01CA6C0A56BD451DA50806E617C5E347&uiid=B77C8CD23AE4EF5DBBD243579F82C9A9&id=14C2CBACE5F54D9E7AFC9320C16AD82F
        window.open(eaf.getEafAppPath() + '/main/DataModel/ClsOper.jsp?clsid=F2634390A9D3C5316C1676783C0C0D43&uiid=B77C8CD23AE4EF5DBBD243579F82C9A9&fromclsid=' + objid);
    }
</script>
<%@ include file='/main/footer.jsp' %>