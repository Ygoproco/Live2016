--Chokoikoi
function c511001721.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001721.target)
	e1:SetOperation(c511001721.activate)
	c:RegisterEffect(e1)
end
function c511001721.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c511001721.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		while tc do
			if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and tc:IsSetCard(0xe6) 
				and tc:IsCanBeSpecialSummoned(e,0,p,false,false) then
				Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(2)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_ATTACK_FINAL)
				e2:SetValue(0)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e3)
			elseif tc:IsType(TYPE_MONSTER) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
				Duel.Damage(p,1000,REASON_EFFECT)
			end
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
