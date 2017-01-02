--Number F0: Future Hope
function c511000192.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c511000192.xyzcon)
	e1:SetOperation(c511000192.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--rank
	c:SetStatus(STATUS_NO_LEVEL,true)
	--indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage val
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511000192,0))
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetTarget(c511000192.atktg)
	e5:SetOperation(c511000192.atkop)
	c:RegisterEffect(e5)
	--prevent destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59251766,0))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c511000192.cost)
	e7:SetOperation(c511000192.op2)
	c:RegisterEffect(e7)
	--prevent effect damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(20450925,0))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c511000192.cost)
	e8:SetOperation(c511000192.op3)
	c:RegisterEffect(e8)
	if not c511000192.global_check then
		c511000192.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511000192.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511000192.ovfilter(c,xyz)
	if c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(511002793) then return false end
	if c:IsOnField() and c:IsFacedown() then return false end
	return (c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyz))
		or c:IsHasEffect(511002116)
end	
function c511000192.doubfilter(c,xyz)
	return c:IsHasEffect(511001225) and (not c.xyzlimit2 or c.xyzlimit2(xyz))
end
function c511000192.amfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsHasEffect,1,nil,511001175)
end
function c511000192.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c511000192.ovfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c511000192.ovfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,c)
	end
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or mg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE))
		and (not min or min<=2 and max>=2)
		and (mg:GetCount()>1 or mg:IsExists(c511000192.doubfilter,1,nil,c) or mg:IsExists(c511000192.amfilter,1,nil))
end
function c511000192.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	local sg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()>0 then
				g:Merge(tc:GetOverlayGroup())
				Duel.Overlay(c,mg)
			end
			tc=og:GetNext()
		end
	else
		local mg=nil
		if og then
			mg=og:Filter(c511000192.ovfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c511000192.ovfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			g=mg:Select(tp,1,1,nil)
		else
			g=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		end
		local tc1=g:GetFirst()
		local mg1=tc1:GetOverlayGroup()
		if mg1:GetCount()~=0 then
			g:Merge(mg1)
			Duel.Overlay(c,mg1)
		end
		if tc1:IsHasEffect(511002116) then
			tc1:RegisterFlagEffect(511002115,RESET_EVENT+0x1fe0000,0,0)
		end
		local eqg=tc1:GetEquipGroup()
		local eqc=eqg:GetFirst()
		while eqc do
			if eqc:IsHasEffect(511001175) then
				mg:AddCard(eqc)
			end
			eqc=eqg:GetNext()
		end
		if not tc1:IsHasEffect(511001225) or (mg:GetCount()>1 and Duel.SelectYesNo(tp,560)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=mg:Select(tp,1,1,tc1)
			local tc2=g2:GetFirst()
			g:Merge(g2)
			local mg2=tc2:GetOverlayGroup()
			if mg2:GetCount()~=0 then
				g:Merge(mg2)
				Duel.Overlay(c,mg2)
			end
			if tc2:IsHasEffect(511002116) then
				tc2:RegisterFlagEffect(511002115,RESET_EVENT+0x1fe0000,0,0)
			end
		end
	end
	g:Remove(Card.IsHasEffect,nil,511002116)
	g:Remove(Card.IsHasEffect,nil,511002115)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c511000192.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,bc,1,0,0)
end
function c511000192.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.GetControl(bc,tp,PHASE_BATTLE,1)
	end
end
function c511000192.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000192.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
end
function c511000192.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c511000192.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c511000192.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c511000192.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,65305468)
	Duel.CreateToken(1-tp,65305468)
end
