--Number 53
function c511010053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511010053.econ)
	e1:SetValue(c511010053.efilter)
	c:RegisterEffect(e1)

	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c511010053.indes)
	c:RegisterEffect(e2)

	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511010053,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetTarget(c511010053.eqtg)
	e3:SetOperation(c511010053.eqop)
	c:RegisterEffect(e3)
	
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetDescription(aux.Stringid(511010053,1))
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c511010053.reptg)
	c:RegisterEffect(e4)
	
	e4:SetLabelObject(e5)
	
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511010053,2))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(511010053)
	e5:SetTarget(c511010053.target)
	e5:SetOperation(c511010053.operation)
	c:RegisterEffect(e5)
	
	--damage reflect
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(511010053,3))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c511010053.damcon)
	e6:SetCost(c511010053.damcost)
	e6:SetTarget(c511010053.damtg)
	e6:SetOperation(c511010053.damop)
	c:RegisterEffect(e6)
	
	
	--93 Summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(511010053,5))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCondition(c511010053.xyzcon)
	e7:SetTarget(c511010053.xyztg)
	e7:SetOperation(c511010053.xyzop)
	c:RegisterEffect(e7)
	
	if not c511010053.global_check then
	c511010053.global_check=true
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_ADJUST)
	ge2:SetCountLimit(1)
	ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge2:SetOperation(c511010053.numchk)
	Duel.RegisterEffect(ge2,0)
	end
end
c511010053.xyz_number=53
function c511010053.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c511010053.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()
end
--------------------------------------------
function c511010053.indes(e,c)
	return not c:IsSetCard(0x48)
end
-------------------------------------------
function c511010053.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c511010053.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c511010053.filter,tp,LOCATION_GRAVE,0,1,nil) end
		local g=Duel.SelectTarget(tp,c511010053.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c511010053.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atkc=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and atkc:IsFaceup() then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c511010053.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atkc:GetAttack())
		tc:RegisterEffect(e2)
	end
end

function c511010053.eqlimit(e,c)
	return e:GetOwner()==c
end

----------------------------------
function c511010053.repfilter(c,ec)
	return c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function c511010053.repcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511010053.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511010053.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c511010053.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE) end
	if Duel.SelectYesNo(tp,aux.Stringid(511010053,2)) then
		local c=e:GetHandler()
		SetLabel(c:GetAttack())
		Duel.RaiseSingleEvent(c,511010053,e,0,0,0,0)
		return true
	else return false end
end

---------------------------------------------------------
function c511010053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=(e:GetLabel()-e:GetHandler():GetAttack())/2
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c511010053.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		if Duel.SelectYesNo(tp,aux.Stringid(511010053,4)) then
			local c=e:GetHandler()
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Recover(tp,d,REASON_EFFECT)
		end
	end
end

----------------------------------------------------------
function c511010053.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp
end
function c511010053.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(511010053)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(511010053,RESET_CHAIN,0,1)
end
function c511010053.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ev/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev/2)
end
function c511010053.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
------------------------------------------------------------
function c511010053.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0 and e:GetHandler():IsType(TYPE_XYZ)
end
function c511010053.xyzfilter(c,e,tp,rk)
	return e:GetHandler():IsCanBeXyzMaterial(c) and c:IsCode(97403510)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c511010053.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c511010053.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511010053.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511010053.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

---------------------------------------------------------
function c511010053.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,23998625)
	Duel.CreateToken(1-tp,23998625)
end