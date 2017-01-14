--Ｄ－アクセレーション
function c100000276.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c100000276.condition)
	e1:SetTarget(c100000276.target)
	e1:SetOperation(c100000276.operation)
	c:RegisterEffect(e1)
end
function c100000276.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c100000276.filter(c)
	return c:IsSetCard(0xc008) and c:GetAttackAnnouncedCount()>0 and c:GetEquipCount()>0 
end
function c100000276.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100000276.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000276.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c100000276.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local eqg=g:GetFirst():GetEquipGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eqg,eqg:GetCount(),0,0)
end
function c100000276.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local eqg=tc:GetEquipGroup()
		if eqg:GetCount()>0 then
			local des=Duel.Destroy(eqg,REASON_EFFECT)
			if tc:IsSetCard(0xc008) then
				local atk=tc:GetAttack()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_ATTACK)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e2:SetValue(atk/2)
				tc:RegisterEffect(e2)
			end
		end
	end
end