--Ring of Life
function c511000658.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e1)
	e1:SetTarget(c511000658.target)
	e1:SetOperation(c511000658.activate)
	c:RegisterEffect(e1)
end
function c511000658.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c511000658.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000658.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,0)
end
function c511000658.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c511000658.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local def=g:GetFirst():GetDefense()
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.Recover(tp,def,REASON_EFFECT)
			Duel.Recover(1-tp,def,REASON_EFFECT)
		end
	end
end
