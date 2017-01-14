--墓穴の道連れ
function c95200004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95200004.target)
	e1:SetOperation(c95200004.activate)
	c:RegisterEffect(e1)
end
function c95200004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c95200004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local sg1=g1:RandomSelect(1-tp,1)
	local sg2=g2:RandomSelect(tp,1)
	sg1:Merge(sg2)
	Duel.SendtoGrave(sg1,REASON_DISCARD+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
