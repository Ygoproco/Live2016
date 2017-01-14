-- Xyz Coat
--scripted by:urielkama
function c511004105.initial_effect(c)
--indes by effect and battle
local e1=Effect.CreateEffect(c)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511004105.target)
e1:SetOperation(c511004105.activate)
c:RegisterEffect(e1)
end
function c511004105.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c511004105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c511004105.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c511004105.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511004105.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end