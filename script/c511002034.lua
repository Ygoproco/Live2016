--クリアウィング・シンクロ・ドラゴン
function c511002034.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82044279,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511002034.condition)
	e1:SetTarget(c511002034.target)
	e1:SetOperation(c511002034.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(82044279,1))
	e2:SetCondition(c511002034.condition2)
	c:RegisterEffect(e2)
end
function c511002034.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLevelAbove(5) and loc==LOCATION_MZONE
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function c511002034.cfilter(c)
	return c:IsLevelAbove(5) and c:IsLocation(LOCATION_MZONE)
end
function c511002034.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and g:IsExists(c511002034.cfilter,1,nil)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function c511002034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc and rc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511002034.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not rc or not rc:IsRelateToEffect(e) then return end
	Duel.NegateRelatedChain(rc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	local e3=nil
	if rc:IsType(TYPE_TRAPMONSTER) then
		e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+0x1fe0000)
	end
	if rc:RegisterEffect(e1) and rc:RegisterEffect(e2) and (e3==nil or rc:RegisterEffect(e3)) and rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local atk=rc:GetTextAttack()
			if atk<=0 then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
