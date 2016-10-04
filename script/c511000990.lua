--Yasushi the Skull Knight
function c511000990.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if c.material_count==nil then
		c511000990.material_count=2
		c511000990.material={78010363,80604091}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c511000990.fscon)
	e1:SetOperation(c511000990.fsop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
end
c511000990.illegal=true
function c511000990.FConditionCheckF(c,chkf)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(chkf)
end
function Auxiliary.FConditionFilter12(c,code,sub,fc)
	return c:IsFusionCode(code) or (sub and c:CheckFusionSubstitute(fc))
end
function Auxiliary.FConditionFilter21(c,code1,code2)
	return c:IsFusionCode(code1,code2)
end
function Auxiliary.FConditionFilter22(c,code1,code2,sub,fc)
	return c:IsFusionCode(code1,code2) or (sub and c:CheckFusionSubstitute(fc))
end
function c511000990.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,gc,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		local b1=0 local b2=0 local bw=0 local bwx=0
		if gc:IsFusionCode(78010363) then b1=1 end
		if gc:IsFusionCode(80604091) then b2=1 end
		if gc:IsHasEffect(511002961) then bwx=1 end
		if gc:CheckFusionSubstitute(e:GetHandler()) then bw=1 end
		if b1+b2+bw==0 then return false end
		if chkf~=PLAYER_NONE and not aux.FConditionCheckF(gc,chkf) then
			mg=mg:Filter(c511000990.FConditionCheckF,nil,chkf)
		end
		local sg=Duel.GetMatchingGroup(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_HAND,0,nil,80604091)
		if b1+b2+bw>1 or bwx==1 then
			if mg:IsExists(aux.FConditionFilter22,1,nil,78010363,80604091,true,e:GetHandler()) then return true
			else return sg:GetCount()>0 end
		elseif b1==1 then
			if mg:IsExists(aux.FConditionFilter12,1,nil,80604091,true,e:GetHandler()) then return true
			else return sg:GetCount()>0 end
		elseif b2==1 then
			return mg:IsExists(aux.FConditionFilter12,1,nil,78010363,true,e:GetHandler())
		else
			if mg:IsExists(aux.FConditionFilter21,1,nil,78010363,80604091) then return true
			else return sg:GetCount()>0 end
		end
	end
	local b1=0 local b2=0 local bw=0 local bwxct=0
	local ct=0
	local fs=chkf==PLAYER_NONE
	local tc=mg:GetFirst()
	while tc do
		local match=false
		if tc:IsFusionCode(78010363) then b1=1 match=true end
		if tc:IsFusionCode(80604091) then b2=1 match=true end
		if tc:IsHasEffect(511002961) then bwxct=bwxct+1 match=true end
		if not tc:IsHasEffect(511002961) and tc:CheckFusionSubstitute(e:GetHandler()) then bw=1 match=true end
		if match then
			if c511000990.FConditionCheckF(tc,chkf) then fs=true end
			ct=ct+1
		end
		tc=mg:GetNext()
	end
	if not fs then return false end
	if ct>1 and b1+b2+bw+bwxct>1 then return true end
	if b2==1 then return false end
	local sg=Duel.GetMatchingGroup(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_HAND,0,nil,80604091)
	return ct>0 and b1+bw+bwxct>0 and sg:GetCount()>0
end
function c511000990.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,gc,e:GetHandler())
	local tc=gc
	local g1=nil
	if gc then
		if chkf~=PLAYER_NONE and not c511000990.FConditionCheckF(gc,chkf) then
			g=g:Filter(c511000990.FConditionCheckF,nil,chkf)
		end
	else
		local sg=g:Filter(Auxiliary.FConditionFilter22,nil,code1,code2,true,e:GetHandler())
		local sg2=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,80604091)
		g:Merge(sg2)
		sg:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,c511000990.FConditionCheckF,1,1,nil,chkf)
		else g1=sg:Select(tp,1,1,nil) end
		tc=g1:GetFirst()
		g:RemoveCard(tc)
	end
	local b1=0 local b2=0 local bw=0 local bwx=0
	if tc:IsFusionCode(78010363) then b1=1 end
	if tc:IsFusionCode(80604091) then b2=1 end
	if tc:IsHasEffect(511002961) then bwx=1 end
	if not tc:IsHasEffect(511002961) and tc:CheckFusionSubstitute(e:GetHandler()) then bw=1 end
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if b1+b2+bw>1 or bwx==1 then
		g2=g:FilterSelect(tp,aux.FConditionFilter22,1,1,nil,78010363,80604091,true,e:GetHandler())
	elseif b1==1 then
		g2=g:FilterSelect(tp,aux.FConditionFilter12,1,1,nil,80604091,true,e:GetHandler())
	elseif b2==1 then
		g2=g:FilterSelect(tp,aux.FConditionFilter12,1,1,nil,78010363,true,e:GetHandler())
	else
		g2=g:FilterSelect(tp,aux.FConditionFilter21,1,1,nil,78010363,80604091)
	end
	if g1 then g2:Merge(g1) end
	Duel.SetFusionMaterial(g2)
end
