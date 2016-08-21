--アマゾネスの鎖使い
function c29654737.initial_effect(c)
	--get card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29654737,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c29654737.condition)
	e1:SetCost(c29654737.cost)
	e1:SetOperation(c29654737.operation)
	c:RegisterEffect(e1)
end
function c29654737.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29654737.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c29654737.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_SEND_REPLACE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetTarget(c29654737.reptg)
			e1:SetOperation(c29654737.repop)
			sg:GetFirst():RegisterEffect(e1)
			sg:GetFirst():RegisterFlagEffect(29654737,0,0,1)
		end
		Duel.ShuffleHand(1-tp)
	end
end
function c29654737.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(29654737)>0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c29654737.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(29654737)
	Duel.SendtoGrave(e:GetHandler(),e:GetHandler():GetReason(),e:GetHandler():GetOwner())
end
