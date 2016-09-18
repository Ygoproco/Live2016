--Crossline Counter
function c511000846.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511000846.condition)
	e1:SetTarget(c511000846.target)
	e1:SetOperation(c511000846.activate)
	c:RegisterEffect(e1)
end
function c511000846.condition(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(ev)
	return ep==tp and Duel.GetTurnPlayer()~=tp and ev~=nil and ev>0 
end
function c511000846.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511000846.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local at=Duel.GetAttacker()
	local ad=Duel.GetAttackTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel()*2)
		tc:RegisterEffect(e1)
	end
	Duel.CalculateDamage(at,tc)
	if ad:IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.Destroy(ad,REASON_BATTLE)
	end
end
