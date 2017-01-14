--Lullaby of Obedience
function c511000168.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000168.cost)
	e1:SetTarget(c511000168.target)
	e1:SetOperation(c511000168.activate)
	c:RegisterEffect(e1)
end
function c511000168.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c511000168.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c511000168.filter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToHand() and c:IsLevelAbove(8)
end
function c511000168.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,c511000168.filter,1-tp,LOCATION_DECK,0,1,1,nil,ac)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	end
end
