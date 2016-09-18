--One-on-One Fight
function c511000476.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000476.target)
	e1:SetOperation(c511000476.activate)
	c:RegisterEffect(e1)
end
function c511000476.filter(c)
	return c:IsFaceup()
end
function c511000476.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c511000476.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,Duel.GetTurnPlayer(),LOCATION_MZONE,0,nil)
	local sg1=nil
	if g1:GetCount()>0 then
		local tg=g1:GetMaxGroup(Card.GetAttack)
		sg1=tg:Select(Duel.GetTurnPlayer(),1,1,nil)
		Duel.HintSelection(sg1)
	end
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,1-Duel.GetTurnPlayer(),LOCATION_MZONE,0,nil)
	local sg2=nil
	if g2:GetCount()>0 then
		local tg=g2:GetMaxGroup(Card.GetAttack)
		sg2=tg:Select(1-Duel.GetTurnPlayer(),1,1,nil)
		Duel.HintSelection(sg2)
	end
	if sg1:GetCount()>0 and sg2:GetCount()>0 then
		Duel.CalculateDamage(sg1:GetFirst(),sg2:GetFirst())
	end
end
