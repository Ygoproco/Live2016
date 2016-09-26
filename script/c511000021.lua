--Burst Impact
function c511000021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000021.condition)
	e1:SetTarget(c511000021.target)
	e1:SetOperation(c511000021.activate)
	c:RegisterEffect(e1)
end
function c511000021.cfilter(c)
	return c:IsFaceup() and c:IsCode(58932615)
end
function c511000021.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c511000021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511000021.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c511000021.tfilter(c)
	return not (c:IsFaceup() and c:IsCode(58932615)) and c:IsDestructable()
end
function c511000021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000021.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c511000021.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,0,g:GetCount()*300)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c19613556.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c511000021.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c511000021.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c511000021.tfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c511000021.tfilter,tp,0,LOCATION_MZONE,nil)
	local ct1=Duel.Destroy(g1,REASON_EFFECT)
	local ct2=Duel.Destroy(g2,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(c511000021.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)Duel.Damage(tp,ct1*300,REASON_EFFECT)
	Duel.Damage(1-tp,ct2*300,REASON_EFFECT)
end