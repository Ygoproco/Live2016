--ダブル・アタック（合体攻撃）
function c100000525.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000525.target)
	e1:SetOperation(c100000525.activate)
	c:RegisterEffect(e1)
end
function c100000525.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0xa008)
end
function c100000525.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100000525.filter,tp,LOCATION_MZONE,0,2,nil)
	 and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c100000525.filter,tp,LOCATION_MZONE,0,2,2,nil,tp)
end
function c100000525.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if not tc1:IsPosition(POS_FACEUP_ATTACK) or not tc2:IsPosition(POS_FACEUP_ATTACK)
	 or not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	tc1:RegisterFlagEffect(100000525,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	tc2:RegisterFlagEffect(100000525,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c100000525.condtion)
	e1:SetValue(tc2:GetAttack())
	e1:SetLabelObject(tc2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(tc1:GetAttack())
	e2:SetLabelObject(tc1)
	tc2:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c100000525.atop)
	e3:SetLabelObject(tc2)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabelObject(tc1)
	tc2:RegisterEffect(e4)
end
function c100000525.condtion(e)
	local oc=e:GetLabelObject()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttacker():GetFlagEffect(100000525)~=0
	 and oc:IsPosition(POS_FACEUP_ATTACK) and Duel.GetAttackTarget()~=nil
end
function c100000525.atop(e,tp,eg,ep,ev,re,r,rp)
	local oc=e:GetLabelObject()
	if Duel.GetAttacker()~=oc and oc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangeAttacker(oc)
	end
end