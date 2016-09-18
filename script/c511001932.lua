--Crystal Spring
function c511001932.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--arrange
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511001932.tdcon)
	e2:SetOperation(c511001932.tdop)
	c:RegisterEffect(e2)
end
function c511001932.cfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:GetPreviousControler()==tp and c:IsControler(tp) 
		and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1034)
end
function c511001932.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511001932.cfilter,nil,tp)
	local tc=g:GetFirst()
	return g:GetCount()==1 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,2,tc,0x1034)
end
function c511001932.tdop(e,tp,eg,ep,ev,re,r,rp)
	local gc=eg:Filter(c511001932.cfilter,nil,tp)
	local tc=gc:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,tc,0x1034)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		sg:AddCard(tc)
		Duel.ShuffleDeck(tp)
		local sgc=sg:GetFirst()
		while sgc do
			Duel.MoveSequence(sgc,0)
			sgc=sg:GetNext()
		end
		Duel.SortDecktop(tp,tp,3)
	end
end
