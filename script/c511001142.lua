--Roll of Fate
function c511001142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001142.target)
	e1:SetOperation(c511001142.operation)
	c:RegisterEffect(e1)
end
function c511001142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1,6) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c511001142.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.TossDice(tp,1)
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DisableShuffleCheck()
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end