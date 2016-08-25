--魔導契約の扉
function c18809562.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18809562.target)
	e1:SetOperation(c18809562.activate)
	c:RegisterEffect(e1)
end
function c18809562.filter(c)
	return (c:GetLevel()==7 or c:GetLevel()==8) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c18809562.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,e:GetHandler(),TYPE_SPELL)
		and Duel.IsExistingMatchingCard(c18809562.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18809562.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18809562,0))
	local ag=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,ag)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c18809562.reptg)
		e1:SetOperation(c18809562.repop)
		ag:GetFirst():RegisterEffect(e1)
		ag:GetFirst():RegisterFlagEffect(18809562,0,0,1)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c18809562.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c18809562.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(18809562)>0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c18809562.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(18809562)
	Duel.SendtoGrave(e:GetHandler(),e:GetHandler():GetReason(),e:GetHandler():GetOwner())
end
