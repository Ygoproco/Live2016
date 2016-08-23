--エクスチェンジ
function c5556668.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5556668.target)
	e1:SetOperation(c5556668.activate)
	c:RegisterEffect(e1)
end
function c5556668.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c5556668.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag1=g2:Select(tp,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetTarget(c5556668.reptg)
	e1:SetOperation(c5556668.repop)
	ag1:GetFirst():RegisterEffect(e1)
	ag1:GetFirst():RegisterFlagEffect(5556668,0,0,1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local ag2=g1:Select(1-tp,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetTarget(c5556668.reptg)
	e1:SetOperation(c5556668.repop)
	ag2:GetFirst():RegisterEffect(e1)
	ag2:GetFirst():RegisterFlagEffect(5556668,0,0,1)
	Duel.SendtoHand(ag1,tp,REASON_EFFECT)
	Duel.SendtoHand(ag2,1-tp,REASON_EFFECT)
end
function c5556668.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(5556668)>0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c5556668.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(5556668)
	Duel.SendtoGrave(e:GetHandler(),e:GetHandler():GetReason(),e:GetHandler():GetOwner())
end