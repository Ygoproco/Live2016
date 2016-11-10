--Hanazumi
function c511001703.initial_effect(c)
	--arrange
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001703.target)
	e1:SetOperation(c511001703.operation)
	c:RegisterEffect(e1)
end
function c511001703.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe6)
end
function c511001703.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001703.filter,tp,LOCATION_DECK,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c511001703.filter,tp,LOCATION_DECK,0,3,3,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(	g)
end
function c511001703.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if ct>0 then
		Duel.ShuffleDeck(tp)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveSequence(tc,0)
			tc=g:GetNext()
		end
		Duel.ConfirmDecktop(tp,ct)
		Duel.SortDecktop(tp,tp,ct)
	end
end
